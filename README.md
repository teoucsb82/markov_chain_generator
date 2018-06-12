# Markov Chain Generator

[Live on Heroku](https://brandless-markov.herokuapp.com)

## Useage
- Can either download this repo and run it locally (`rake db:migrate` first, then `rails s` to launch) or it is also currently hosted on [Heroku](https://brandless-markov.herokuapp.com)
- Enter in a twitter username to generate a 140 char tweet using the Markov Chain algorithm.
  - Generated tweets are visable at `/users/<username>` (#show path).
  - The app will grab the most recent 20 tweets from that username, then when the page loads will randomly grab 3 of those texts and generate up to 140 characters from those tweets.
    - The texts themselves are persisted, and reloading the page will generate new chains on the fly.
  - The markov chain outputs are NOT persisted based on the way I set this up. If we wanted, could easily save each one as a `belongs_to` pattern on the top-level `user` and have them saved to a DB.

## Tech highlights
- TDD coverage around the custom `lib` classes for the `ChainGenerator` and the `FrequencyTable`. See `/spec` directory for tests.
- Hooked up to call live Twitter API via username.
  - Used the [twitter gem](https://github.com/sferik/twitter/tree/master/examples)
- Live on heroku running Ruby 2/Rails 4.
- Barebones styling (per requirements, chose to avoid bells and whistles)
- [friendly_id gem](https://github.com/norman/friendly_id) to have a prettier #show method. 
  - Ex: "users/teoucsb82" instead of "users/1"

## Known issues/gotchas
- Requires a publicly available twitter username. Will not work on private accounts. No error handling for such an event.
- Intentionally chose to avoid "enter in some custom text and you'll get a chain". 
  - The logic is easily extendable to handle such a workflow, but felt it a better demo to jump straight into "provide a twitter user and we'll do the rest for you."
  - Could simply build a model that had a an attribute to hold a string, and then call `ChainGenerator.new(string).generate` to get a chain from that text.
- The chain generator output is not 100% perfect. I would love to extend this to take in options (ex: `max_word_length`, or `enforce_random_start_word` etc) to allow more flexibility. I have placeholders in the code for "@options" that are currently not connected to any logic.
  - It also does not parse certain punctuation properly. Key breakpoints for end-of-word (ex: `.`, `!`, `?`) are covered, but others (ex: `(` or `)`) are not accounted for and will lead to interesting output.
- Commits are not in the best shape. Ideally would have rebased and cleaned them up.

## Notes/Thought Process
- Would have liked to test all the things (controllers, models), but in the interest of time only covered the tests for algorithms. 
- No security whatsover. In theory, someone could hammer this endpoint and cause me to get blocked by twitter for rate limiting.
- Tried to get up an MVP as quickly as possible, and hoping I didn't miss any specific requirements / captured the spirit of the assignment.