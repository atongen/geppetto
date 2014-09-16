# Geppetto

A simple web-app that generates starter vagrant and puppet files for projects

## Installation

```bash
$ git clone https://github.com/atongen/geppetto.git
$ cd geppetto
$ git checkout develop
$ bundle install
$ foreman start
```

The app is also hosted on heroku: http://geppetto.herokuapp.com/

## Usage

1. Visit the url for the running application
2. Fill out the form with the requirements for your app
3. Submit, collect zip file
4. Extract zip file into your application
5. Tweak Vagrantfile and puppet manifests to suit your needs
6. run `vagrant up`

## Contributing

1. Fork it ( https://github.com/atongen/geppetto/fork )
2. Use git-flow to create a feature branch (https://github.com/nvie/gitflow)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Make sure your feature branch is rebased on latest develop branch upstream
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request
