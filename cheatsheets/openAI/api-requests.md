[Overview](https://platform.openai.com/)[Documentation](https://platform.openai.com/docs)[Examples](https://platform.openai.com/examples)[Playground](https://platform.openai.com/playground)

[Upgrade](https://platform.openai.com/account/billing)

S

Personal

Get started

[Introduction](https://platform.openai.com/docs/introduction)[Quickstart tutorial](https://platform.openai.com/docs/quickstart)[Libraries](https://platform.openai.com/docs/libraries)[Models](https://platform.openai.com/docs/models)[Usage policies](https://platform.openai.com/docs/usage-policies)

Guides

[Text completion](https://platform.openai.com/docs/guides/completion)[Code completion](https://platform.openai.com/docs/guides/code)[Image generation](https://platform.openai.com/docs/guides/images)[Fine-tuning](https://platform.openai.com/docs/guides/fine-tuning)[Embeddings](https://platform.openai.com/docs/guides/embeddings)[Moderation](https://platform.openai.com/docs/guides/moderation)[Rate limits](https://platform.openai.com/docs/guides/rate-limits)[Error codes](https://platform.openai.com/docs/guides/error-codes)[Safety best practices](https://platform.openai.com/docs/guides/safety-best-practices)[Production best practices](https://platform.openai.com/docs/guides/production-best-practices)

API Reference

[Introduction](https://platform.openai.com/docs/api-reference/introduction)[Authentication](https://platform.openai.com/docs/api-reference/authentication)[Making requests](https://platform.openai.com/docs/api-reference/making-requests)[Models](https://platform.openai.com/docs/api-reference/models)[Completions](https://platform.openai.com/docs/api-reference/completions)[Edits](https://platform.openai.com/docs/api-reference/edits)[Images](https://platform.openai.com/docs/api-reference/images)[Embeddings](https://platform.openai.com/docs/api-reference/embeddings)[Files](https://platform.openai.com/docs/api-reference/files)[Fine-tunes](https://platform.openai.com/docs/api-reference/fine-tunes)[Moderations](https://platform.openai.com/docs/api-reference/moderations)[Engines](https://platform.openai.com/docs/api-reference/engines)[Parameter details](https://platform.openai.com/docs/api-reference/parameter-details)

[## Introduction](https://platform.openai.com/docs/api-reference/introduction)

You can interact with the API through HTTP requests from any language, via our official Python bindings, our official Node.js library, or a [community-maintained library](https://platform.openai.com/docs/libraries/community-libraries).

To install the official Python bindings, run the following command:

```
pip install openai
```

To install the official Node.js library, run the following command in your Node.js project directory:

```
npm install openai
```

[## Authentication](https://platform.openai.com/docs/api-reference/authentication)

The OpenAI API uses API keys for authentication. Visit your [API Keys](https://platform.openai.com/account/api-keys) page to retrieve the API key you'll use in your requests.

**Remember that your API key is a secret!** Do not share it with others or expose it in any client-side code (browsers, apps). Production requests must be routed through your own backend server where your API key can be securely loaded from an environment variable or key management service.

All API requests should include your API key in an `Authorization` HTTP header as follows:

```
Authorization: Bearer YOUR_API_KEY
```

[### Requesting organization](https://platform.openai.com/docs/api-reference/requesting-organization)

For users who belong to multiple organizations, you can pass a header to specify which organization is used for an API request. Usage from these API requests will count against the specified organization's subscription quota.

Example curl command:

```
`1 2 3` curl https://api.openai.com/v1/models \
 -H 'Authorization: Bearer YOUR_API_KEY' \ -H 'OpenAI-Organization: org-ZVCmawDkQc4mPUaLzUPWN5wu'
```

Example with the `openai` Python package:

```
`1 2 3 4 5` import os import openai openai.organization = "org-ZVCmawDkQc4mPUaLzUPWN5wu"  openai.api_key = os.getenv("OPENAI_API_KEY") openai.Model.list()
```

Example with the `openai` Node.js package:

```
`1 2 3 4 5 6 7` import { Configuration, OpenAIApi } from  "openai"; const configuration = new Configuration({  organization: "org-ZVCmawDkQc4mPUaLzUPWN5wu",
  apiKey: process.env.OPENAI_API_KEY, });
const openai = new OpenAIApi(configuration); const response = await openai.listEngines();
```

Organization IDs can be found on your [Organization settings](https://platform.openai.com/account/org-settings) page.

[## Making requests](https://platform.openai.com/docs/api-reference/making-requests)

You can paste the command below into your terminal to run your first API request. Make sure to replace `YOUR_API_KEY` with your secret API key.

```
`1 2 3 4` curl https://api.openai.com/v1/completions \ -H "Content-Type: application/json" \ -H "Authorization: Bearer YOUR_API_KEY" \ -d '{"model": "text-davinci-003", "prompt": "Say this is a test", "temperature": 0, "max_tokens": 7}'
```

This request queries the Davinci model to complete the text starting with a prompt of "*Say this is a test*". The `max_tokens` parameter sets an upper bound on how many [tokens](https://platform.openai.com/tokenizer) the API will return. You should get a response back that resembles the following:

```
`1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19` {
  "id": "cmpl-GERzeJQ4lvqPk8SkZu4XMIuR",
  "object": "text_completion",
  "created": 1586839808,
  "model": "text-davinci:003",
  "choices": [
        {
  "text": "\n\nThis is indeed a test",
  "index": 0,
  "logprobs": null,
  "finish_reason": "length"         }
    ],
  "usage": {
  "prompt_tokens": 5,
  "completion_tokens": 7,
  "total_tokens": 12     }
}
```

Now you've generated your first completion. If you concatenate the prompt and the completion text (which the API will do for you if you set the `echo` parameter to `true`), the resulting text is "*Say this is a test. This is indeed a test.*" You can also set the `stream` parameter to `true` for the API to stream back text (as [data-only server-sent events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events#Event_stream_format)).

[## Models](https://platform.openai.com/docs/api-reference/models)

List and describe the various models available in the API. You can refer to the [Models](https://platform.openai.com/docs/models) documentation to understand what models are available and the differences between them.

[## List models](https://platform.openai.com/docs/api-reference/models/list)

get https://api.openai.com/v1/models

Lists the currently available models, and provides basic information about each one such as the owner and availability.

Example request

curl

```
`1 2` curl https://api.openai.com/v1/models \
  -H 'Authorization: Bearer YOUR_API_KEY'
```

Response

```
`1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23` {
  "data": [
    {
  "id": "model-id-0",
  "object": "model",
  "owned_by": "organization-owner",
  "permission": [...]
    },
    {
  "id": "model-id-1",
  "object": "model",
  "owned_by": "organization-owner",
  "permission": [...]
    },
    {
  "id": "model-id-2",
  "object": "model",
  "owned_by": "openai",
  "permission": [...]
    },
  ],
  "object": "list"  }
```

[## Retrieve model](https://platform.openai.com/docs/api-reference/models/retrieve)

get https://api.openai.com/v1/models/{model}

Retrieves a model instance, providing basic information about the model such as the owner and permissioning.

### Path parameters

[](#models/retrieve-model)

model

string

Required

The ID of the model to use for this request

Example request

text-davinci-003

curl

```
`1 2` curl https://api.openai.com/v1/models/text-davinci-003 \
  -H 'Authorization: Bearer YOUR_API_KEY'
```

Response

text-davinci-003

```
`1 2 3 4 5 6` {
  "id": "text-davinci-003",
  "object": "model",
  "owned_by": "openai",
  "permission": [...] }
```

[## Completions](https://platform.openai.com/docs/api-reference/completions)

Given a prompt, the model will return one or more predicted completions, and can also return the probabilities of alternative tokens at each position.

[## Create completion](https://platform.openai.com/docs/api-reference/completions/create)

post https://api.openai.com/v1/completions

Creates a completion for the provided prompt and parameters

### Request body

[](#completions/create-model)

model

string

Required

ID of the model to use. You can use the [List models](https://platform.openai.com/docs/api-reference/models/list) API to see all of your available models, or see our [Model overview](https://platform.openai.com/docs/models/overview) for descriptions of them.

[](#completions/create-prompt)

prompt

string or array

Optional

Defaults to &lt;|endoftext|&gt;

The prompt(s) to generate completions for, encoded as a string, array of strings, array of tokens, or array of token arrays.

Note that &lt;|endoftext|&gt; is the document separator that the model sees during training, so if a prompt is not specified the model will generate as if from the beginning of a new document.

[](#completions/create-suffix)

suffix

string

Optional

Defaults to null

The suffix that comes after a completion of inserted text.

[](#completions/create-max_tokens)

max_tokens

integer

Optional

Defaults to 16

The maximum number of [tokens](https://platform.openai.com/tokenizer) to generate in the completion.

The token count of your prompt plus `max_tokens` cannot exceed the model's context length. Most models have a context length of 2048 tokens (except for the newest models, which support 4096).

[](#completions/create-temperature)

temperature

number

Optional

Defaults to 1

What [sampling temperature](https://towardsdatascience.com/how-to-sample-from-language-models-682bceb97277) to use. Higher values means the model will take more risks. Try 0.9 for more creative applications, and 0 (argmax sampling) for ones with a well-defined answer.

We generally recommend altering this or `top_p` but not both.

[](#completions/create-top_p)

top_p

number

Optional

Defaults to 1

An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered.

We generally recommend altering this or `temperature` but not both.

[](#completions/create-n)

n

integer

Optional

Defaults to 1

How many completions to generate for each prompt.

**Note:** Because this parameter generates many completions, it can quickly consume your token quota. Use carefully and ensure that you have reasonable settings for `max_tokens` and `stop`.

[](#completions/create-stream)

stream

boolean

Optional

Defaults to false

Whether to stream back partial progress. If set, tokens will be sent as data-only [server-sent events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events#Event_stream_format) as they become available, with the stream terminated by a `data: [DONE]` message.

[](#completions/create-logprobs)

logprobs

integer

Optional

Defaults to null

Include the log probabilities on the `logprobs` most likely tokens, as well the chosen tokens. For example, if `logprobs` is 5, the API will return a list of the 5 most likely tokens. The API will always return the `logprob` of the sampled token, so there may be up to `logprobs+1` elements in the response.

The maximum value for `logprobs` is 5. If you need more than this, please contact us through our [Help center](https://help.openai.com) and describe your use case.

[](#completions/create-echo)

echo

boolean

Optional

Defaults to false

Echo back the prompt in addition to the completion

[](#completions/create-stop)

stop

string or array

Optional

Defaults to null

Up to 4 sequences where the API will stop generating further tokens. The returned text will not contain the stop sequence.

[](#completions/create-presence_penalty)

presence_penalty

number

Optional

Defaults to 0

Number between -2.0 and 2.0. Positive values penalize new tokens based on whether they appear in the text so far, increasing the model's likelihood to talk about new topics.

[See more information about frequency and presence penalties.](https://platform.openai.com/docs/api-reference/parameter-details)

[](#completions/create-frequency_penalty)

frequency_penalty

number

Optional

Defaults to 0

Number between -2.0 and 2.0. Positive values penalize new tokens based on their existing frequency in the text so far, decreasing the model's likelihood to repeat the same line verbatim.

[See more information about frequency and presence penalties.](https://platform.openai.com/docs/api-reference/parameter-details)

[](#completions/create-best_of)

best_of

integer

Optional

Defaults to 1

Generates `best_of` completions server-side and returns the "best" (the one with the highest log probability per token). Results cannot be streamed.

When used with `n`, `best_of` controls the number of candidate completions and `n` specifies how many to return – `best_of` must be greater than `n`.

**Note:** Because this parameter generates many completions, it can quickly consume your token quota. Use carefully and ensure that you have reasonable settings for `max_tokens` and `stop`.

[](#completions/create-logit_bias)

logit_bias

map

Optional

Defaults to null

Modify the likelihood of specified tokens appearing in the completion.

Accepts a json object that maps tokens (specified by their token ID in the GPT tokenizer) to an associated bias value from -100 to 100. You can use this [tokenizer tool](https://platform.openai.com/tokenizer?view=bpe) (which works for both GPT-2 and GPT-3) to convert text to token IDs. Mathematically, the bias is added to the logits generated by the model prior to sampling. The exact effect will vary per model, but values between -1 and 1 should decrease or increase likelihood of selection; values like -100 or 100 should result in a ban or exclusive selection of the relevant token.

As an example, you can pass `{"50256": -100}` to prevent the &lt;|endoftext|&gt; token from being generated.

[](#completions/create-user)

user

string

Optional

A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse. [Learn more](https://platform.openai.com/docs/guides/safety-best-practices/end-user-ids).

Example request

text-davinci-003

curl

```
`1 2 3 4 5 6 7 8 9` curl https://api.openai.com/v1/completions \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_API_KEY' \
  -d '{
  "model": "text-davinci-003",
  "prompt": "Say this is a test",
  "max_tokens": 7,
  "temperature": 0
}'
```

Parameters

text-davinci-003

```
`1 2 3 4 5 6 7 8 9 10 11` {
  "model": "text-davinci-003",
  "prompt": "Say this is a test",
  "max_tokens": 7,
  "temperature": 0,
  "top_p": 1,
  "n": 1,
  "stream": false,
  "logprobs": null,
  "stop": "\n"  }
```

Response

text-davinci-003

```
`1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19` {
  "id": "cmpl-uqkvlQyYK7bGYrRHQ0eXlWi7",
  "object": "text_completion",
  "created": 1589478378,
  "model": "text-davinci-003",
  "choices": [
    {
  "text": "\n\nThis is indeed a test",
  "index": 0,
  "logprobs": null,
  "finish_reason": "length"     }
  ],
  "usage": {
  "prompt_tokens": 5,
  "completion_tokens": 7,
  "total_tokens": 12   }
}
```

[## Edits](https://platform.openai.com/docs/api-reference/edits)

Given a prompt and an instruction, the model will return an edited version of the prompt.

[## Create edit](https://platform.openai.com/docs/api-reference/edits/create)

post https://api.openai.com/v1/edits

Creates a new edit for the provided input, instruction, and parameters.

### Request body

[](#edits/create-model)

model

string

Required

ID of the model to use. You can use the `text-davinci-edit-001` or `code-davinci-edit-001` model with this endpoint.

[](#edits/create-input)

input

string

Optional

Defaults to ''

The input text to use as a starting point for the edit.

[](#edits/create-instruction)

instruction

string

Required

The instruction that tells the model how to edit the prompt.

[](#edits/create-n)

n

integer

Optional

Defaults to 1

How many edits to generate for the input and instruction.

[](#edits/create-temperature)

temperature

number

Optional

Defaults to 1

What [sampling temperature](https://towardsdatascience.com/how-to-sample-from-language-models-682bceb97277) to use. Higher values means the model will take more risks. Try 0.9 for more creative applications, and 0 (argmax sampling) for ones with a well-defined answer.

We generally recommend altering this or `top_p` but not both.

[](#edits/create-top_p)

top_p

number

Optional

Defaults to 1

An alternative to sampling with temperature, called nucleus sampling, where the model considers the results of the tokens with top_p probability mass. So 0.1 means only the tokens comprising the top 10% probability mass are considered.

We generally recommend altering this or `temperature` but not both.

Example request

text-davinci-edit-001

curl

```
`1 2 3 4 5 6 7 8` curl https://api.openai.com/v1/edits \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_API_KEY' \
  -d '{
  "model": "text-davinci-edit-001",
  "input": "What day of the wek is it?",
  "instruction": "Fix the spelling mistakes"
}'
```

Parameters

text-davinci-edit-001

```
`1 2 3 4 5` {
  "model": "text-davinci-edit-001",
  "input": "What day of the wek is it?",
  "instruction": "Fix the spelling mistakes", }
```

Response

```
`1 2 3 4 5 6 7 8 9 10 11 12 13 14 15` {
  "object": "edit",
  "created": 1589478378,
  "choices": [
    {
  "text": "What day of the week is it?",
  "index": 0,
    }
  ],
  "usage": {
  "prompt_tokens": 25,
  "completion_tokens": 32,
  "total_tokens": 57   }
}
```

[## Images](https://platform.openai.com/docs/api-reference/images)

Given a prompt and/or an input image, the model will generate a new image.

Related guide: [Image generation](https://platform.openai.com/docs/guides/images)

[## Create image<br>Beta](https://platform.openai.com/docs/api-reference/images/create)

post https://api.openai.com/v1/images/generations

Creates an image given a prompt.

### Request body

[](#images/create-prompt)

prompt

string

Required

A text description of the desired image(s). The maximum length is 1000 characters.

[](#images/create-n)

n

integer

Optional

Defaults to 1

The number of images to generate. Must be between 1 and 10.

[](#images/create-size)

size

string

Optional

Defaults to 1024x1024

The size of the generated images. Must be one of `256x256`, `512x512`, or `1024x1024`.

[](#images/create-response_format)

response_format

string

Optional

Defaults to url

The format in which the generated images are returned. Must be one of `url` or `b64_json`.

[](#images/create-user)

user

string

Optional

A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse. [Learn more](https://platform.openai.com/docs/guides/safety-best-practices/end-user-ids).

Example request

curl

```
`1 2 3 4 5 6 7 8` curl https://api.openai.com/v1/images/generations \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_API_KEY' \
  -d '{
  "prompt": "A cute baby sea otter",
  "n": 2,
  "size": "1024x1024"
}'
```

Parameters

```
`1 2 3 4 5` {
  "prompt": "A cute baby sea otter",
  "n": 2,
  "size": "1024x1024"  }
```

Response

```
`1 2 3 4 5 6 7 8 9 10 11` {
  "created": 1589478378,
  "data": [
    {
  "url": "https://..."     },
    {
  "url": "https://..."     }
  ]
}
```

[## Create image edit<br>Beta](https://platform.openai.com/docs/api-reference/images/create-edit)

post https://api.openai.com/v1/images/edits

Creates an edited or extended image given an original image and a prompt.

### Request body

[](#images/create-edit-image)

image

string

Required

The image to edit. Must be a valid PNG file, less than 4MB, and square. If mask is not provided, image must have transparency, which will be used as the mask.

[](#images/create-edit-mask)

mask

string

Optional

An additional image whose fully transparent areas (e.g. where alpha is zero) indicate where `image` should be edited. Must be a valid PNG file, less than 4MB, and have the same dimensions as `image`.

[](#images/create-edit-prompt)

prompt

string

Required

A text description of the desired image(s). The maximum length is 1000 characters.

[](#images/create-edit-n)

n

integer

Optional

Defaults to 1

The number of images to generate. Must be between 1 and 10.

[](#images/create-edit-size)

size

string

Optional

Defaults to 1024x1024

The size of the generated images. Must be one of `256x256`, `512x512`, or `1024x1024`.

[](#images/create-edit-response_format)

response_format

string

Optional

Defaults to url

The format in which the generated images are returned. Must be one of `url` or `b64_json`.

[](#images/create-edit-user)

user

string

Optional

A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse. [Learn more](https://platform.openai.com/docs/guides/safety-best-practices/end-user-ids).

Example request

curl

```
`1 2 3 4 5 6 7` curl https://api.openai.com/v1/images/edits \
  -H 'Authorization: Bearer YOUR_API_KEY' \
  -F image='@otter.png' \
  -F mask='@mask.png' \
  -F prompt="A cute baby sea otter wearing a beret" \
  -F n=2 \
  -F size="1024x1024"
```

Response

```
`1 2 3 4 5 6 7 8 9 10 11` {
  "created": 1589478378,
  "data": [
    {
  "url": "https://..."     },
    {
  "url": "https://..."     }
  ]
}
```

[## Create image variation<br>Beta](https://platform.openai.com/docs/api-reference/images/create-variation)

post https://api.openai.com/v1/images/variations

Creates a variation of a given image.

### Request body

[](#images/create-variation-image)

image

string

Required

The image to use as the basis for the variation(s). Must be a valid PNG file, less than 4MB, and square.

[](#images/create-variation-n)

n

integer

Optional

Defaults to 1

The number of images to generate. Must be between 1 and 10.

[](#images/create-variation-size)

size

string

Optional

Defaults to 1024x1024

The size of the generated images. Must be one of `256x256`, `512x512`, or `1024x1024`.

[](#images/create-variation-response_format)

response_format

string

Optional

Defaults to url

The format in which the generated images are returned. Must be one of `url` or `b64_json`.

[](#images/create-variation-user)

user

string

Optional

A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse. [Learn more](https://platform.openai.com/docs/guides/safety-best-practices/end-user-ids).

Example request

curl

```
`1 2 3 4 5` curl https://api.openai.com/v1/images/variations \
  -H 'Authorization: Bearer YOUR_API_KEY' \
  -F image='@otter.png' \
  -F n=2 \
  -F size="1024x1024"
```

Response

```
`1 2 3 4 5 6 7 8 9 10 11` {
  "created": 1589478378,
  "data": [
    {
  "url": "https://..."     },
    {
  "url": "https://..."     }
  ]
}
```

[## Embeddings](https://platform.openai.com/docs/api-reference/embeddings)

Get a vector representation of a given input that can be easily consumed by machine learning models and algorithms.

Related guide: [Embeddings](https://platform.openai.com/docs/guides/embeddings)

[## Create embeddings](https://platform.openai.com/docs/api-reference/embeddings/create)

post https://api.openai.com/v1/embeddings

Creates an embedding vector representing the input text.

### Request body

[](#embeddings/create-model)

model

string

Required

ID of the model to use. You can use the [List models](https://platform.openai.com/docs/api-reference/models/list) API to see all of your available models, or see our [Model overview](https://platform.openai.com/docs/models/overview) for descriptions of them.

[](#embeddings/create-input)

input

string or array

Required

Input text to get embeddings for, encoded as a string or array of tokens. To get embeddings for multiple inputs in a single request, pass an array of strings or array of token arrays. Each input must not exceed 8192 tokens in length.

[](#embeddings/create-user)

user

string

Optional

A unique identifier representing your end-user, which can help OpenAI to monitor and detect abuse. [Learn more](https://platform.openai.com/docs/guides/safety-best-practices/end-user-ids).

Example request

curl

```
`1 2 3 4 5 6` curl https://api.openai.com/v1/embeddings \
  -X POST \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"input": "The food was delicious and the waiter...",
       "model": "text-embedding-ada-002"}'
```

Parameters

```
`1 2 3 4` {
  "model": "text-embedding-ada-002",
  "input": "The food was delicious and the waiter..."  }
```

Response

```
`1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20` {
  "object": "list",
  "data": [
    {
  "object": "embedding",
  "embedding": [
  0.0023064255,
 -0.009327292,
 .... (1056 floats total for ada) -0.0028842222,
      ],
  "index": 0     }
  ],
  "model": "text-embedding-ada-002",
  "usage": {
  "prompt_tokens": 8,
  "total_tokens": 8   }
}
```

[## Files](https://platform.openai.com/docs/api-reference/files)

Files are used to upload documents that can be used with features like [Fine-tuning](https://platform.openai.com/docs/api-reference/fine-tunes).

[## List files](https://platform.openai.com/docs/api-reference/files/list)

get https://api.openai.com/v1/files

Returns a list of files that belong to the user's organization.

Example request

curl

```
`1 2` curl https://api.openai.com/v1/files \
  -H 'Authorization: Bearer YOUR_API_KEY'
```

Response

```
`1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21` {
  "data": [
    {
  "id": "file-ccdDZrC3iZVNiQVeEA6Z66wf",
  "object": "file",
  "bytes": 175,
  "created_at": 1613677385,
  "filename": "train.jsonl",
  "purpose": "search"     },
    {
  "id": "file-XjGxS3KTG0uNmNOK362iJua3",
  "object": "file",
  "bytes": 140,
  "created_at": 1613779121,
  "filename": "puppy.jsonl",
  "purpose": "search"     }
  ],
  "object": "list"  }
```

[## Upload file](https://platform.openai.com/docs/api-reference/files/upload)

post https://api.openai.com/v1/files

Upload a file that contains document(s) to be used across various endpoints/features. Currently, the size of all the files uploaded by one organization can be up to 1 GB. Please contact us if you need to increase the storage limit.

### Request body

[](#files/upload-file)

file

string

Required

Name of the [JSON Lines](https://jsonlines.readthedocs.io/en/latest/) file to be uploaded.

If the `purpose` is set to "fine-tune", each line is a JSON record with "prompt" and "completion" fields representing your [training examples](https://platform.openai.com/docs/guides/fine-tuning/prepare-training-data).

[](#files/upload-purpose)

purpose

string

Required

The intended purpose of the uploaded documents.

Use "fine-tune" for [Fine-tuning](https://platform.openai.com/docs/api-reference/fine-tunes). This allows us to validate the format of the uploaded file.

Example request

curl

```
`1 2 3 4` curl https://api.openai.com/v1/files \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -F purpose="fine-tune" \
  -F file='@mydata.jsonl'
```

Response

```
`1 2 3 4 5 6 7 8` {
  "id": "file-XjGxS3KTG0uNmNOK362iJua3",
  "object": "file",
  "bytes": 140,
  "created_at": 1613779121,
  "filename": "mydata.jsonl",
  "purpose": "fine-tune"  }
```

[## Delete file](https://platform.openai.com/docs/api-reference/files/delete)

delete https://api.openai.com/v1/files/{file_id}

Delete a file.

### Path parameters

[](#files/delete-file_id)

file_id

string

Required

The ID of the file to use for this request

Example request

curl

```
`1 2 3` curl https://api.openai.com/v1/files/file-XjGxS3KTG0uNmNOK362iJua3 \
  -X DELETE \
  -H 'Authorization: Bearer YOUR_API_KEY'
```

Response

```
`1 2 3 4 5` {
  "id": "file-XjGxS3KTG0uNmNOK362iJua3",
  "object": "file",
  "deleted": true  }
```

[## Retrieve file](https://platform.openai.com/docs/api-reference/files/retrieve)

get https://api.openai.com/v1/files/{file_id}

Returns information about a specific file.

### Path parameters

[](#files/retrieve-file_id)

file_id

string

Required

The ID of the file to use for this request

Example request

curl

```
`1 2` curl https://api.openai.com/v1/files/file-XjGxS3KTG0uNmNOK362iJua3 \
  -H 'Authorization: Bearer YOUR_API_KEY'
```

Response

```
`1 2 3 4 5 6 7 8` {
  "id": "file-XjGxS3KTG0uNmNOK362iJua3",
  "object": "file",
  "bytes": 140,
  "created_at": 1613779657,
  "filename": "mydata.jsonl",
  "purpose": "fine-tune"  }
```

[## Retrieve file content](https://platform.openai.com/docs/api-reference/files/retrieve-content)

get https://api.openai.com/v1/files/{file_id}/content

Returns the contents of the specified file

### Path parameters

[](#files/retrieve-content-file_id)

file_id

string

Required

The ID of the file to use for this request

Example request

curl

```
`1 2` curl https://api.openai.com/v1/files/file-XjGxS3KTG0uNmNOK362iJua3/content \
  -H 'Authorization: Bearer YOUR_API_KEY' > file.jsonl
```

[## Fine-tunes](https://platform.openai.com/docs/api-reference/fine-tunes)

Manage fine-tuning jobs to tailor a model to your specific training data.

Related guide: [Fine-tune models](https://platform.openai.com/docs/guides/fine-tuning)

[## Create fine-tune<br>Beta](https://platform.openai.com/docs/api-reference/fine-tunes/create)

post https://api.openai.com/v1/fine-tunes

Creates a job that fine-tunes a specified model from a given dataset.

Response includes details of the enqueued job including job status and the name of the fine-tuned models once complete.

[Learn more about Fine-tuning](https://platform.openai.com/docs/guides/fine-tuning)

### Request body

[](#fine-tunes/create-training_file)

training_file

string

Required

The ID of an uploaded file that contains training data.

See [upload file](https://platform.openai.com/docs/api-reference/files/upload) for how to upload a file.

Your dataset must be formatted as a JSONL file, where each training example is a JSON object with the keys "prompt" and "completion". Additionally, you must upload your file with the purpose `fine-tune`.

See the [fine-tuning guide](https://platform.openai.com/docs/guides/fine-tuning/creating-training-data) for more details.

[](#fine-tunes/create-validation_file)

validation_file

string

Optional

The ID of an uploaded file that contains validation data.

If you provide this file, the data is used to generate validation metrics periodically during fine-tuning. These metrics can be viewed in the [fine-tuning results file](https://platform.openai.com/docs/guides/fine-tuning/analyzing-your-fine-tuned-model). Your train and validation data should be mutually exclusive.

Your dataset must be formatted as a JSONL file, where each validation example is a JSON object with the keys "prompt" and "completion". Additionally, you must upload your file with the purpose `fine-tune`.

See the [fine-tuning guide](https://platform.openai.com/docs/guides/fine-tuning/creating-training-data) for more details.

[](#fine-tunes/create-model)

model

string

Optional

Defaults to curie

The name of the base model to fine-tune. You can select one of "ada", "babbage", "curie", "davinci", or a fine-tuned model created after 2022-04-21. To learn more about these models, see the [Models](https://platform.openai.com/docs/models) documentation.

[](#fine-tunes/create-n_epochs)

n_epochs

integer

Optional

Defaults to 4

The number of epochs to train the model for. An epoch refers to one full cycle through the training dataset.

[](#fine-tunes/create-batch_size)

batch_size

integer

Optional

Defaults to null

The batch size to use for training. The batch size is the number of training examples used to train a single forward and backward pass.

By default, the batch size will be dynamically configured to be ~0.2% of the number of examples in the training set, capped at 256 - in general, we've found that larger batch sizes tend to work better for larger datasets.

[](#fine-tunes/create-learning_rate_multiplier)

learning\_rate\_multiplier

number

Optional

Defaults to null

The learning rate multiplier to use for training. The fine-tuning learning rate is the original learning rate used for pretraining multiplied by this value.

By default, the learning rate multiplier is the 0.05, 0.1, or 0.2 depending on final `batch_size` (larger learning rates tend to perform better with larger batch sizes). We recommend experimenting with values in the range 0.02 to 0.2 to see what produces the best results.

[](#fine-tunes/create-prompt_loss_weight)

prompt\_loss\_weight

number

Optional

Defaults to 0.01

The weight to use for loss on the prompt tokens. This controls how much the model tries to learn to generate the prompt (as compared to the completion which always has a weight of 1.0), and can add a stabilizing effect to training when completions are short.

If prompts are extremely long (relative to completions), it may make sense to reduce this weight so as to avoid over-prioritizing learning the prompt.

[](#fine-tunes/create-compute_classification_metrics)

compute\_classification\_metrics

boolean

Optional

Defaults to false

If set, we calculate classification-specific metrics such as accuracy and F-1 score using the validation set at the end of every epoch. These metrics can be viewed in the [results file](https://platform.openai.com/docs/guides/fine-tuning/analyzing-your-fine-tuned-model).

In order to compute classification metrics, you must provide a `validation_file`. Additionally, you must specify `classification_n_classes` for multiclass classification or `classification_positive_class` for binary classification.

[](#fine-tunes/create-classification_n_classes)

classification\_n\_classes

integer

Optional

Defaults to null

The number of classes in a classification task.

This parameter is required for multiclass classification.

[](#fine-tunes/create-classification_positive_class)

classification\_positive\_class

string

Optional

Defaults to null

The positive class in binary classification.

This parameter is needed to generate precision, recall, and F1 metrics when doing binary classification.

[](#fine-tunes/create-classification_betas)

classification_betas

array

Optional

Defaults to null

If this is provided, we calculate F-beta scores at the specified beta values. The F-beta score is a generalization of F-1 score. This is only used for binary classification.

With a beta of 1 (i.e. the F-1 score), precision and recall are given the same weight. A larger beta score puts more weight on recall and less on precision. A smaller beta score puts more weight on precision and less on recall.

[](#fine-tunes/create-suffix)

suffix

string

Optional

Defaults to null

A string of up to 40 characters that will be added to your fine-tuned model name.

For example, a `suffix` of "custom-model-name" would produce a model name like `ada:ft-your-org:custom-model-name-2022-02-15-04-21-04`.

Example request

curl

```
`1 2 3 4 5 6 7` curl https://api.openai.com/v1/fine-tunes \
  -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -d '{
  "training_file": "file-XGinujblHPwGLSztz8cPS8XY"
}'
```

Response

```
`1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36` {
  "id": "ft-AF1WoRqd3aJAHsqc9NY7iL8F",
  "object": "fine-tune",
  "model": "curie",
  "created_at": 1614807352,
  "events": [
    {
  "object": "fine-tune-event",
  "created_at": 1614807352,
  "level": "info",
  "message": "Job enqueued. Waiting for jobs ahead to complete. Queue number: 0."     }
  ],
  "fine_tuned_model": null,
  "hyperparams": {
  "batch_size": 4,
  "learning_rate_multiplier": 0.1,
  "n_epochs": 4,
  "prompt_loss_weight": 0.1,
  },
  "organization_id": "org-...",
  "result_files": [],
  "status": "pending",
  "validation_files": [],
  "training_files": [
    {
  "id": "file-XGinujblHPwGLSztz8cPS8XY",
  "object": "file",
  "bytes": 1547276,
  "created_at": 1610062281,
  "filename": "my-data-train.jsonl",
  "purpose": "fine-tune-train"     }
  ],
  "updated_at": 1614807352, }
```

[## List fine-tunes<br>Beta](https://platform.openai.com/docs/api-reference/fine-tunes/list)

get https://api.openai.com/v1/fine-tunes

List your organization's fine-tuning jobs

Example request

curl

```
`1 2` curl https://api.openai.com/v1/fine-tunes \
  -H 'Authorization: Bearer YOUR_API_KEY'
```

Response

```
`1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21` {
  "object": "list",
  "data": [
    {
  "id": "ft-AF1WoRqd3aJAHsqc9NY7iL8F",
  "object": "fine-tune",
  "model": "curie",
  "created_at": 1614807352,
  "fine_tuned_model": null,
  "hyperparams": { ... },
  "organization_id": "org-...",
  "result_files": [],
  "status": "pending",
  "validation_files": [],
  "training_files": [ { ... } ],
  "updated_at": 1614807352,
    },
    { ... },
    { ... }
  ]
}
```

[## Retrieve fine-tune<br>Beta](https://platform.openai.com/docs/api-reference/fine-tunes/retrieve)

get https://api.openai.com/v1/fine-tunes/{fine\_tune\_id}

Gets info about the fine-tune job.

[Learn more about Fine-tuning](https://platform.openai.com/docs/guides/fine-tuning)

### Path parameters

[](#fine-tunes/retrieve-fine_tune_id)

fine\_tune\_id

string

Required

The ID of the fine-tune job

Example request

curl

```
`1 2` curl https://api.openai.com/v1/fine-tunes/ft-AF1WoRqd3aJAHsqc9NY7iL8F \
  -H "Authorization: Bearer YOUR_API_KEY"
```

Response

```
`1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69` {
  "id": "ft-AF1WoRqd3aJAHsqc9NY7iL8F",
  "object": "fine-tune",
  "model": "curie",
  "created_at": 1614807352,
  "events": [
    {
  "object": "fine-tune-event",
  "created_at": 1614807352,
  "level": "info",
  "message": "Job enqueued. Waiting for jobs ahead to complete. Queue number: 0."     },
    {
  "object": "fine-tune-event",
  "created_at": 1614807356,
  "level": "info",
  "message": "Job started."     },
    {
  "object": "fine-tune-event",
  "created_at": 1614807861,
  "level": "info",
  "message": "Uploaded snapshot: curie:ft-acmeco-2021-03-03-21-44-20."     },
    {
  "object": "fine-tune-event",
  "created_at": 1614807864,
  "level": "info",
  "message": "Uploaded result files: file-QQm6ZpqdNwAaVC3aSz5sWwLT."     },
    {
  "object": "fine-tune-event",
  "created_at": 1614807864,
  "level": "info",
  "message": "Job succeeded."     }
  ],
  "fine_tuned_model": "curie:ft-acmeco-2021-03-03-21-44-20",
  "hyperparams": {
  "batch_size": 4,
  "learning_rate_multiplier": 0.1,
  "n_epochs": 4,
  "prompt_loss_weight": 0.1,
  },
  "organization_id": "org-...",
  "result_files": [
    {
  "id": "file-QQm6ZpqdNwAaVC3aSz5sWwLT",
  "object": "file",
  "bytes": 81509,
  "created_at": 1614807863,
  "filename": "compiled_results.csv",
  "purpose": "fine-tune-results"     }
  ],
  "status": "succeeded",
  "validation_files": [],
  "training_files": [
    {
  "id": "file-XGinujblHPwGLSztz8cPS8XY",
  "object": "file",
  "bytes": 1547276,
  "created_at": 1610062281,
  "filename": "my-data-train.jsonl",
  "purpose": "fine-tune-train"     }
  ],
  "updated_at": 1614807865, }
```

[## Cancel fine-tune<br>Beta](https://platform.openai.com/docs/api-reference/fine-tunes/cancel)

post https://api.openai.com/v1/fine-tunes/{fine\_tune\_id}/cancel

Immediately cancel a fine-tune job.

### Path parameters

[](#fine-tunes/cancel-fine_tune_id)

fine\_tune\_id

string

Required

The ID of the fine-tune job to cancel

Example request

curl

```
`1 2 3` curl https://api.openai.com/v1/fine-tunes/ft-AF1WoRqd3aJAHsqc9NY7iL8F/cancel \
  -X POST \
  -H "Authorization: Bearer YOUR_API_KEY"
```

Response

```
`1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24` {
  "id": "ft-xhrpBbvVUzYGo8oUO1FY4nI7",
  "object": "fine-tune",
  "model": "curie",
  "created_at": 1614807770,
  "events": [ { ... } ],
  "fine_tuned_model": null,
  "hyperparams": { ... },
  "organization_id": "org-...",
  "result_files": [],
  "status": "cancelled",
  "validation_files": [],
  "training_files": [
    {
  "id": "file-XGinujblHPwGLSztz8cPS8XY",
  "object": "file",
  "bytes": 1547276,
  "created_at": 1610062281,
  "filename": "my-data-train.jsonl",
  "purpose": "fine-tune-train"     }
  ],
  "updated_at": 1614807789, }
```

[## List fine-tune events<br>Beta](https://platform.openai.com/docs/api-reference/fine-tunes/events)

get https://api.openai.com/v1/fine-tunes/{fine\_tune\_id}/events

Get fine-grained status updates for a fine-tune job.

### Path parameters

[](#fine-tunes/events-fine_tune_id)

fine\_tune\_id

string

Required

The ID of the fine-tune job to get events for.

### Query parameters

[](#fine-tunes/events-stream)

stream

boolean

Optional

Defaults to false

Whether to stream events for the fine-tune job. If set to true, events will be sent as data-only [server-sent events](https://developer.mozilla.org/en-US/docs/Web/API/Server-sent_events/Using_server-sent_events#Event_stream_format) as they become available. The stream will terminate with a `data: [DONE]` message when the job is finished (succeeded, cancelled, or failed).

If set to false, only events generated so far will be returned.

Example request

curl

```
`1 2` curl https://api.openai.com/v1/fine-tunes/ft-AF1WoRqd3aJAHsqc9NY7iL8F/events \
  -H "Authorization: Bearer YOUR_API_KEY"
```

Response

```
`1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35` {
  "object": "list",
  "data": [
    {
  "object": "fine-tune-event",
  "created_at": 1614807352,
  "level": "info",
  "message": "Job enqueued. Waiting for jobs ahead to complete. Queue number: 0."     },
    {
  "object": "fine-tune-event",
  "created_at": 1614807356,
  "level": "info",
  "message": "Job started."     },
    {
  "object": "fine-tune-event",
  "created_at": 1614807861,
  "level": "info",
  "message": "Uploaded snapshot: curie:ft-acmeco-2021-03-03-21-44-20."     },
    {
  "object": "fine-tune-event",
  "created_at": 1614807864,
  "level": "info",
  "message": "Uploaded result files: file-QQm6ZpqdNwAaVC3aSz5sWwLT."     },
    {
  "object": "fine-tune-event",
  "created_at": 1614807864,
  "level": "info",
  "message": "Job succeeded."     }
  ]
}
```

[## Delete fine-tune model<br>Beta](https://platform.openai.com/docs/api-reference/fine-tunes/delete-model)

delete https://api.openai.com/v1/models/{model}

Delete a fine-tuned model. You must have the Owner role in your organization.

### Path parameters

[](#fine-tunes/delete-model-model)

model

string

Required

The model to delete

Example request

curl

```
`1 2 3` curl https://api.openai.com/v1/models/curie:ft-acmeco-2021-03-03-21-44-20 \
  -X DELETE \
  -H "Authorization: Bearer YOUR_API_KEY"
```

Response

```
`1 2 3 4 5` {
  "id": "curie:ft-acmeco-2021-03-03-21-44-20",
  "object": "model",
  "deleted": true  }
```

[## Moderations](https://platform.openai.com/docs/api-reference/moderations)

Given a input text, outputs if the model classifies it as violating OpenAI's content policy.

Related guide: [Moderations](https://platform.openai.com/docs/guides/moderation)

[## Create moderation](https://platform.openai.com/docs/api-reference/moderations/create)

post https://api.openai.com/v1/moderations

Classifies if text violates OpenAI's Content Policy

### Request body

[](#moderations/create-input)

input

string or array

Required

The input text to classify

[](#moderations/create-model)

model

string

Optional

Defaults to text-moderation-latest

Two content moderations models are available: `text-moderation-stable` and `text-moderation-latest`.

The default is `text-moderation-latest` which will be automatically upgraded over time. This ensures you are always using our most accurate model. If you use `text-moderation-stable`, we will provide advanced notice before updating the model. Accuracy of `text-moderation-stable` may be slightly lower than for `text-moderation-latest`.

Example request

curl

```
`1 2 3 4 5 6` curl https://api.openai.com/v1/moderations \
  -H 'Content-Type: application/json' \
  -H 'Authorization: Bearer YOUR_API_KEY' \
  -d '{
  "input": "I want to kill them."
}'
```

Parameters

```
`1 2 3` {
  "input": "I want to kill them."  }
```

Response

```
`1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27` {
  "id": "modr-5MWoLO",
  "model": "text-moderation-001",
  "results": [
    {
  "categories": {
  "hate": false,
  "hate/threatening": true,
  "self-harm": false,
  "sexual": false,
  "sexual/minors": false,
  "violence": true,
  "violence/graphic": false       },
  "category_scores": {
  "hate": 0.22714105248451233,
  "hate/threatening": 0.4132447838783264,
  "self-harm": 0.005232391878962517,
  "sexual": 0.01407341007143259,
  "sexual/minors": 0.0038522258400917053,
  "violence": 0.9223177433013916,
  "violence/graphic": 0.036865197122097015       },
  "flagged": true     }
  ]
}
```

[## Engines](https://platform.openai.com/docs/api-reference/engines)

The Engines endpoints are deprecated.

Please use their replacement, [Models](https://platform.openai.com/docs/api-reference/models), instead. [Learn more](https://help.openai.com/TODO).

These endpoints describe and provide access to the various engines available in the API.

[## List engines<br>Deprecated](https://platform.openai.com/docs/api-reference/engines/list)

get https://api.openai.com/v1/engines

Lists the currently available (non-finetuned) models, and provides basic information about each one such as the owner and availability.

Example request

curl

```
`1 2` curl https://api.openai.com/v1/engines \
  -H 'Authorization: Bearer YOUR_API_KEY'
```

Response

```
`1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23` {
  "data": [
    {
  "id": "engine-id-0",
  "object": "engine",
  "owner": "organization-owner",
  "ready": true     },
    {
  "id": "engine-id-2",
  "object": "engine",
  "owner": "organization-owner",
  "ready": true     },
    {
  "id": "engine-id-3",
  "object": "engine",
  "owner": "openai",
  "ready": false     },
  ],
  "object": "list"  }
```

[## Retrieve engine<br>Deprecated](https://platform.openai.com/docs/api-reference/engines/retrieve)

get https://api.openai.com/v1/engines/{engine_id}

Retrieves a model instance, providing basic information about it such as the owner and availability.

### Path parameters

[](#engines/retrieve-engine_id)

engine_id

string

Required

The ID of the engine to use for this request

Example request

text-davinci-003

curl

```
`1 2` curl https://api.openai.com/v1/engines/text-davinci-003 \
  -H 'Authorization: Bearer YOUR_API_KEY'
```

Response

text-davinci-003

```
`1 2 3 4 5 6` {
  "id": "text-davinci-003",
  "object": "engine",
  "owner": "openai",
  "ready": true  }
```

[## Parameter details](https://platform.openai.com/docs/api-reference/parameter-details)

**Frequency and presence penalties**

The frequency and presence penalties found in the [Completions API](https://platform.openai.com/docs/api-reference/completions) can be used to reduce the likelihood of sampling repetitive sequences of tokens. They work by directly modifying the logits (un-normalized log-probabilities) with an additive contribution.

```
mu[j] -> mu[j] - c[j] * alpha_frequency - float(c[j] > 0) * alpha_presence
```

Where:

- `mu[j]` is the logits of the j-th token
- `c[j]` is how often that token was sampled prior to the current position
- `float(c[j] > 0)` is 1 if `c[j] > 0` and 0 otherwise
- `alpha_frequency` is the frequency penalty coefficient
- `alpha_presence` is the presence penalty coefficient

As we can see, the presence penalty is a one-off additive contribution that applies to all tokens that have been sampled at least once and the frequency penalty is a contribution that is proportional to how often a particular token has already been sampled.

Reasonable values for the penalty coefficients are around 0.1 to 1 if the aim is to just reduce repetitive samples somewhat. If the aim is to strongly suppress repetition, then one can increase the coefficients up to 2, but this can noticeably degrade the quality of samples. Negative values can be used to increase the likelihood of repetition.
