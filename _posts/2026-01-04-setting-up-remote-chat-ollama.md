---
layout: post
title: Setting up your own Ollama LLM agent
date: 2026-01-04 17:17:16
description: Setting up your own LLM for VS Code & Web search
tags: llm agent
categories: projects
---

I've really come around on making use of AI (i.e., LLMs) as a tool for quickly iterating on ideas and making the rote work of software development and analysis smoother. I've also realized that I don't really want to continue incentivizing the construction of large datacenters and the ravenous appetite for more and more computing resources. In my experience both in academia and my limited experience in industry, I realized that you don't really need the biggest models to get what you need done. Don't get me wrong, the biggest models do work really well, but if we're faced with the true cost of a token, at what point is it worth it to roll your own solution? I anticipate we'll collectively be faced with this sometime in the next couple of years, and even if we aren't it's worth evaluating the marginal utility of the big models over the small ones especially for narrow-defined tasks.

To this end I wanted to play with 'small' LLMs: I have a Mac Mini with 16GB of RAM, so I set out to see if I can run my own LLM and use it to serve my development/assistant needs. I decided to set up my computer as a local server that will run Ollama and a series of connected servers to act as my own 'local' LLM that I can use as a drop-in replacement in my workflows (i.e., consulting with an LLM and as a code assistant in Cursor/VS Code). I'll accept a little latency if it means I know where all the compute is happening and how my data is being used.

In this post I'll describe how to set up Ollama and a simple chat interface that connects to whatever LLM you want that you can fit on your machine. I arbitrarily decided on the latest Gemma3 4b model that was quantized in such a way that it can run on my Mac Mini M4 with 16GB of RAM, with plenty of room to spare for enabling different behaviors of the model. I've since given the local model the ability to use tools like web-search, and I'll supply the code I used to build this. It should be straightforward to take this and run it on anywhere with a docker container. 

Here's a rough diagram of how you'll interact with the LLM:
your browser 
-> Gradio chat interface
	-> chat gateway
            | \=> a) tool server
            |         1) SearXNG search engine
            |===> b) LLM hosted via ollama API

Here's what you'll eventually be installing (if you don't have it already):
 1) Docker Desktop
 2) Ollama
 3) uv / python
 4) Gradio
 5) Tailscale (recommended for remote access)

 



## Installing Ollama and downloading LLMs

Ollama is an open source tool for running large language models (LLMs) locally on your own machine. It was built originally upon the AI inference engine llama.cpp, which is the key library that allows running inference on pre-trained LLMs. They have since expanded and stream-lined their tooling to enable the use of multimodal models and cloud-provider models. Their UI is extremely smooth, however we will largely be interacting with it through the CLI and the API it will run for us to talk to our models.

The first step will be to download Ollama at (https://ollama.com/download)[https://ollama.com/download] on the machine you want to use as a server (here my Mac Mini I'll call `mm`). In a terminal on `mm` issue the following to make sure it's installed correctly:

`ollama --version`

You should see a line that reads: `ollama version is x.xx.x`

Take a look at the rest of the interface if you're not familiar with it. If you issue a simple `ollama` command you should see the list of commands and flags you can run:

```
Usage:
  ollama [flags]
  ollama [command]

Available Commands:
  serve       Start ollama
  create      Create a model
  show        Show information for a model
  run         Run a model
  stop        Stop a running model
  pull        Pull a model from a registry
  push        Push a model to a registry
  signin      Sign in to ollama.com
  signout     Sign out from ollama.com
  list        List models
  ps          List running models
  cp          Copy a model
  rm          Remove a model
  help        Help about any command

Flags:
  -h, --help      help for ollama
  -v, --version   Show version information
```
Here we will be largely concerning ourselves with `serve` `pull` `run` `stop` `list` `ps`

To download a model from the Ollama model library you issue a pull command with a `<Model>:<tag>` parameter specifying which model and type you want:

`ollama pull gemma3:4b`

This will pull the Gemma3 model with 4 billion parameters. Other Gemma3 models available are 1B, 4B, 12B, and 27B parameters, each of which increases the amount of RAM necessary to run the model. It might sound like a lot, but these models are largely quantized, so they don't actually occupy a lot of RAM (though it does blow up pretty fast as you travel up in # parameters)

Issue the following command to interact with your Gemma3 model to test that it works

`ollama run gemma3:4b`

This will open a chat interface on the command line you can issue commands with.

Now that we've downloaded Ollama and a model we'll move on to actually building the tooling around it we'll give the model tools to use.

## Tailscale for Remote Connection

The second component to this, if you want to reliably make use of your secondary machine, is to install some sort of VPN that will connect the machine running the LLM and your local machine. It is more secure than just forwarding and exposing your LLM machine to the open internet. To this end I suggest installing something like Tailscale, which you will install and run on both your LLM machine and on the machine you want to access the LLM on. 

Note: I use Tailscale here because it ultimately required no setup to enable my two machines to talk to each other. Other solutions would have required installing something like OpenVPN and/or changing out my router. **This setup is designed for private use over a VPN. You should not expose it publicly without authentication and rate limits**

When you turn Tailscale on, you should be able to find in the tailscale settings an IP address for both machines (the usual range is 100.*.*.*). Use this to issue an `ssh` command to see if you can successfully login remotely to your LLM machine.

## SearXNG for Searching (With nginx)

Now that we can access the LLM machine remotely, we can start working towards a tool server that affords the LLM to issue tool commands, allowing it to interact with components that exist outside of the chat session. Here we will stand up a SearXNG instance, which is an open-source metasearch engine that can search across numerous search services (spanning ~200 services from Google to Wikidata to OpenAlex to Public Domain Image Archive). 

### Docker

Docker saves us a lot of trouble in setting up this instance -- we can just use the `docker compose` command with a docker-compose.yaml file that points to an official searxng docker image. Here's an example docker-compose.yaml

```yaml
services:
  searxng:
    image: searxng/searxng:latest
    container_name: searxng
    environment:
      - INSTANCE_NAME=local-searxng
      - BASE_URL=http://localhost:8080/
    volumes:
      - searxng-data:/etc/searxng
    restart: unless-stopped
    networks:
      - searxnet

  nginx:
    image: nginx:alpine
    container_name: searxng-nginx
    ports:
      - "127.0.0.1:8080:8080"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - searxng
    restart: unless-stopped
    networks:
```

Make sure that your docker daemon is running, and then issuing a simple `docker compose up -d` in the same directory will look for your docker-compose.yaml file and start up the nginx & searxng services. For context, the nginx is included to act as a reverse proxy, so the searxng service isn't caught off-guard by unexpected traffic requests.

#### Updating the Settings

In the settings.yaml file in the searxng container, find the following and make sure to add `json`:

```yaml
search:
  formats:
    - html
    - json
```

And be sure to allow unthrottled requests:

```yaml
server:
  limiter: false
```

When you change those notes, you would need to spin down and up your container:

```
docker compose down
docker compose up -d
```


## Tool Server

If you have gotten to this point, you should be able to talk with your Ollama model separately, and you should have a docker container running for your nginx/searXNG setup. Now we need to start to hook things up so that the model you'll interact with can actually issue web-searches. Here's an example of what the tool server can look like:

```Python
from fastapi import FastAPI
from pydantic import BaseModel
import httpx
from bs4 import BeautifulSoup
from readability import Document
import logging

logging.basicConfig(
    level=logging.DEBUG,
    format="%(asctime)s %(levelname)s [%(name)s] %(message)s",
)
logger = logging.getLogger('toolServer')
logger.setLevel(logging.DEBUG)

app = FastAPI(title="Local Tool Server")

TOOLURL = "http://localhost:8080/search"

class SearchReq(BaseModel):
     query: str
     num_results: int=5

class OpenReq(BaseModel):
     url: str
     max_chars: int = 200000

# Enables the search tool for an agent
@app.post("/search")
async def search(req: SearchReq):
   params = {"q": req.query, "format":"json"}
   logger.debug("Params for search: %s", params)
   async with httpx.AsyncClient(timeout=20) as client:
       r = await client.get(TOOLURL, params=params)
       r.raise_for_status()
       data = r.json()
   logger.debug("Returned data from search: %s", data)
   results = []
   if data.get("results") is not None:
       for item in data.get("results")[:req.num_results]:
            results.append({
               "title": item.get("title"),
               "url": item.get("url"),
               "snippet": item.get("content"),
               "source": item.get("engine"),
            })
   print(results)
   return {"results": results}

# Enables opening a website for crawling for an agent
@app.post("/open")
async def open_url(req: OpenReq):
   async with httpx.AsyncClient(timeout=25, follow_redirects=True) as client:
      r = await client.get(req.url)
      r.raise_for_status()
      html = r.text
   
   doc = Document(html)
   title = doc.short_title()
   cleaned_html = doc.summary()
   
   soup = BeautifulSoup(cleaned_html, "html.parser")
   text = soup.get_text("\n", stripe=True)

   if len(text) > req.max_chars:
       text = text[:req.max_chars] + "\n..."
   return {"title": title, "url": req.url, "text":text}
```

You can run this with a command like: 

`uvicorn tool_server:app --host [tailscale IP] --port [tool_port]`

## Chat Gateway

Now we need a means to connect the model with the tool server, and then connect the model with the user. Here's an example uvicorn script we can run for this:

```Python

import json
import re
import requests
from fastapi import FastAPI
from pydantic import BaseModel
import logging

logging.basicConfig(
    level=logging.DEBUG,
    format="%(asctime)s %(levelname)s [%(name)s] %(message)s",
)

logger = logging.getLogger("chat_gateway")
logger.setLevel(logging.DEBUG)



OLLAMA_URL = "http://127.0.0.1:11434/v1/chat/completions"
TOOL_SERVER_URL = "http://127.0.0.1:[tool_port]" 
MODEL = "gemma3:latest"

def strip_code_fences(text: str) -> str:
    t = text.strip()

    if t.startswith("```"):
        # remove opening ``` or ```json
        t = re.sub(r"^\s*```[a-zA-Z0-9_-]*\s*", "", t)
        # remove closing ```
        t = re.sub(r"\s*```\s*$", "", t)

    return t.strip()

SYSTEM = """You are a tool-using assistant. Follow these rules exactly.

TOOLS
- search: {"query": string, "top_k": integer}

WHEN TO CALL TOOLS
- If the user asks about recent info, news, current events, or anything you are not certain about, you MUST call search.
- If the user asks for sources/citations, you MUST call search unless the user provided the sources in the conversation.

TOOL CALL FORMAT (STRICT)
When calling a tool, output ONLY ONE JSON object and nothing else. And if you include a tool call, you must only include the tool call, no extra text before or after it. No narration.
No markdown. No code fences. No extra text.
Schema:
{"tool":"search","args":{"query":"...","top_k":5}}

AFTER TOOL RESULTS (STRICT GROUNDING)
- Use ONLY the tool results to answer. Do NOT use outside knowledge.
- Every factual claim must be supported by at least one URL from the tool results.
- If the tool results do not contain the answer, say: "I couldn't find this in the search results."

CITATIONS
- Cite sources inline using parentheses with the URL, e.g. (https://example.com).
- Do not invent URLs.

OUTPUT
- If you are calling a tool: output the tool-call JSON only. No text before or after. No narration.
- Otherwise: output a normal answer with citations when required.
"""


app = FastAPI()

class ChatIn(BaseModel):
    message: str
    history: list[dict] = [] 

#for checking if there's a tool call
TOOL_JSON_RE = re.compile(r"^\s*\{.*\}\s*$", re.S)

def ollama_chat(messages):
    r = requests.post(OLLAMA_URL, json={"model": MODEL, "messages": messages}, timeout=300)
    return r.json()["choices"][0]["message"]["content"]

def call_tool(tool, args):
    if tool == "search":
        logger.debug("Calling search tool with args: %s", args) 
        # tool call should be a POST to  /search with {"query":..., "top_k":...}
        r = requests.post(f"{TOOL_SERVER_URL}/search", json=args, timeout=60)
        r.raise_for_status()
        logger.debug("Reply from tool: %s", r.json())
        return r.json()
    raise ValueError(f"Unknown tool: {tool}")

@app.post("/chat")
def chat(payload: ChatIn):
    logger.info("Received chat request")
    messages = [{"role": "system", "content": SYSTEM}] + payload.history + [{"role": "user", "content": payload.message}]
    logger.debug("Payload: %s", payload)

    assistant = ollama_chat(messages)
    logger.debug("First reply from initial chat: %s", assistant)
    # If the model requested a tool call:
    if TOOL_JSON_RE.match(strip_code_fences(assistant.strip())):
        call = json.loads(strip_code_fences(assistant.strip()))
        logger.debug("Tool found")
        tool_result = call_tool(call["tool"], call.get("args", {}))

        # Feed the tool result back
        messages.append({"role": "assistant", "content": assistant})
        messages.append({
          "role": "user",
          "content": (
          "Tool result (JSON):\n"
          f"{json.dumps(tool_result, ensure_ascii=False)}\n\n"
          "Now answer the user's question using ONLY the tool result. "
          "If you cite sources, include the URL in parentheses."
          )
        })
        logger.debug("Messages: %s", messages)
        assistant = ollama_chat(messages)
    logger.debug("Raw reply: %s", assistant)
    return {"reply": assistant}
```

Run the chat gateway much like the toolserver:

`uvicorn chat_gateway:app --host [tailscale IP] --port [chat_gateway_port]`

Now you should have the ability to POST a request to your chat gateway that will respond to a message you send it. For instance

```bash
curl -s http://[remote_machine_tailscale_ip]:[chat_gateway_port]/chat \                                                                                  
  -H "Content-Type: application/json" \
  -d '{"message":"Hello! Just say hi back.","history":[]}' \
  ; echo

{"reply":"Hi back! How can I help you today?"}
```

You can also confirm that it can web-search with a specific query that is past it's training date:

```bash

curl -s http://[remote_machine_tailscale_ip]:[chat_gateway_port]/chat \                                                    
  -H "Content-Type: application/json" \
  -d '{"message":"Hello! Can you search for news results about Venezuela and date it?.","history":[]}' \
  ; echo

{"reply":"Here’s a summary of recent news regarding Venezuela, as of the search results:\n\nAs of today, January 9, 2026, the United States has seized its fifth oil tanker linked to Venezuela (https://abcnews.go.com/International/live-updates/venezuela-live-updates-trump-give-details-after-us/?id=127792811). U.S. President Donald Trump met with oil company executives to discuss Venezuela (https://www.reuters.com/world/venezuela/). The U.S. has long demanded the release of detained Venezuelan President Nicolás Maduro (https://www.bbc.com/news/topics/cg41ylwvwgxt).  Venezuelaanalysis provides ongoing news and analysis (https://venezuelanalysis.com/)."}
```


## Chat Gradio UI

If that wasn't enough for you, and you want some sort of UI to interact with the model, we'll run through a simple Gradio UI that can start as a means for replicating your own ChatGPT-like interface

```Python
import requests
import gradio as gr

CHAT_GATEWAY_URL = 'http://[remote_machine_tailscale_ip]:[chat_gateway_port]/chat'


def to_gateway_history(chat_history):
  # gr.ChatInterface expects [(user, assistant),...]
  out = []
  if chat_history is None:
    return out
  for u, a in chat_history:
    if u:
      out.append({"role": "user", "content": u})
    if a:
      out.append({"role": "assistant", "content": a})
  return out
 
def one_turn(user_message: str) -> str:
  r = requests.post(
          CHAT_GATEWAY_URL,
          json={'message': user_message, 'history': []},
          timeout=120
          )
  r.raise_for_status()
  return r.json()['reply']

demo = gr.Interface(
         fn=one_turn,
         inputs=gr.Textbox(label="User"),
         outputs=gr.Textbox(label="Response"),
         title="Chat Gateway UI"
       )

if __name__ == '__main__':
  demo.launch(server_name="[remote_machine_tailscale_interface]", server_port=[ui_port])
```

This should give you the a rough interface that you can log into on your local machine's browser (http://xyz:port)! 

Code for the current version of this project will be found at TODO: XYZ

## Conclusion

Here's what you should have in startup order:
1. `ollama serve`
2. `docker compose up -d (searxng)`
3. `uvicorn tool_server`
4. `uvicorn chat_gateway`
5. `python gradio_ui.py`

As a development note, I run my local servers all on their own `screen`, perhaps you use `tmux` but you should consider a tool like this to quickly manage the locally deployed servers. There are also likely better ways to actually run these servers, but that's out of the scope of this post.


Thanks for the time, happy building.