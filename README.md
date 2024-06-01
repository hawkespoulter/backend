To setup clone the repository and run the following commands:
```bash
bundle install
rails db:create
rails db:migrate

# Create a user
rails c

User.create

u = User.first
u.name = "Jonny Bravo"
u.role = "Chad
u.save

ctrl + d to exit the console

rails s
```
```

you will need ruby-3.2.2 install and you may possibly need to install rails as well. If you do run into problems all the specific dependencies are in the Gemfile. Oh also postgres will need to be set
up on your machine. If you run into any issues please let me know.