## Domino Web

### Setup

- To Install: `npm install`
- To Test: `npm test`
- `npm install -g gulp` if not already installed

We use [foreman](https://github.com/ddollar/foreman) to manage our config vars in environment. Copy `.env.example` to `.env` and add the required values.

Run `foreman run gulp` and access the application at port 8080.

### Structure

```

/client
  /components      # global react components
  /css             # global styles and mixins
  /img
  /models          # client side models
  /pages           # main pages / domain-specific modules
  /vendor          # 3rd party libs

  index.html       # main index
  router.coffee    # routes
  start.coffee     # app starting point

/public            # compiled client files
start.coffee       # simple express server to serve client

```
