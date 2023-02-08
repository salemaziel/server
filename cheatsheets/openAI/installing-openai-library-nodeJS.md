# Open AI - NodeJS Library

## Installing
```
npm install openai
```


## Using Library

Once library is installed, can use bindings + secret key (API KEY) to run an example like the following:

### Programatically
```
const { Configuration, OpenAIApi } = require("openai");
const configuration = new Configuration({
  apiKey: process.env.OPENAI_API_KEY,
});
const openai = new OpenAIApi(configuration);
const response = await openai.createCompletion({
  model: "text-davinci-003",
  prompt: "Say this is a test",
  temperature: 0,
  max_tokens: 7,
});
```

### CLI utility
- no CLI utility yet :(


