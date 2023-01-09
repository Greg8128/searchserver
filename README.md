# Setup
Clone the project. You can do this with `git clone $project_git_url`.
Make the config file.
In your favorite web browser, set up searchserver as a search engine.
Then, build and run searchserver.

# Config file
Make a file called `.searchserver` in your home directory. You can do this by running `touch .searchserver` from your home directory.
It is treated as a YAML file. An example config file is:

```
port: 3000
patterns:
# hoogle      
    - - h!(.*)
      - https://hoogle.haskell.org/?hoogle=\1

# Default search engine
    - - (.*)
      - https://duckduckgo.com/?q=\1         # duckduckgo
      # - https://www.google.com/search?q=\1 # google
      # - https://www.bing.com/search?q=\1   # bing
      # - https://yandex.com/search/?text=\1 # yandex
```

`port` is the port that searchserver runs from.
`patterns` is a list of search-replace pairs. Each one is a list with the first entry being a perl-style regular expression, and the second one being a URL template string in which captured entries can be substituted, with "\1" being the first substituted term, "\2" the second, and so forth. The first regex in the list that matches the query is used to substitue the query into the corresponding URL template string.
The query is stripped of leading and trailing whitespace and the regular expression is surrounded by "^" and "$" to ensure that it must fit the entire query.

# Browser configuration
In Microsoft Edge, go to `Privacy, Search and Services > Address Bar and Search > Manage Search Engines`, and add a new search engine with URL string "http://localhost:3000/?q=%s".
In Firefox, install the "Add custom search engine" extension, then add a search engine with URL string "http://localhost:3000/?q=%s"

