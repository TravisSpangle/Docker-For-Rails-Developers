[##](##) Chapter 1.

  What is Docker
    Packaging, Distribution, Runtime, Infrastructure creation, Orchestration and scaling

  A holistic view of the app, single command line installation and setup, easy version management of dependencies, huge docker ecosystem, simulate production like envrionments locally.

Containers are the running instance. Images are the specifications for that container to be built.

Generating a New Rails app without Ruby Installed
  `docker run -i -t --rm -v ${PWD}:/usr/src/app ruby:2.6 bash`
  i: interactive
  t: psuedo tty session
  rm: create a throwaway container
  v: mount a volumn. When we exit the session the contents of this volumn will appear in the current directory.

## Chapter 2.

This was a rough chapter. I'm not sure if there were mistakes on my part and/or tech has changed since the book was written. The publisher has updated their site and lost the Eratta.

The solution was to toss everything and start with chapter one.

In chapter one, specify the version of rails - `gem intsall rails 5.2`

In chapter two, the docker file the WORKDIR should be `WORKDIR /usr/src/app/myapp`

To run the app, specify the working directory: `docker run -w "/usr/src/app" -p 3000:3000 969e0e855a2e bin/rails s -b 0.0.0.0`

We can then visit the site in our browser, `https://localhost:3000`


  `docker run -w "/usr/src/app" -p 3000:3000 969e0e855a2e bin/rails s -b 0.0.0.0`
  w: specify working directory
  p: port mapping - the running port on this container to my os to access the process
  b: Binds all IP address to 0.0.0.0


## Chapter 3.

Here we use CMD to auto run our command for us.

https://docs.docker.com/engine/reference/builder/#cmd

CMD has 3 forms of use. It may be preferable to use the shell form:
`CMD bin/rails s -b 0.0.0.0`

With the shell form, Docker will run this command prepended with /bin/bash -c

Since bin/bash is the process we are connected to and not bin/rails we risk losting the ability to terminate the rails server.

The author seems to prefer the exec form.

`CMD ["bin/rails", "s", "-b", "0.0.0.0"]`

This is treated as a JSON array - so we must use double quotes and not single quotes per the standard - https://www.json.org/json-en.html.

There can only be one CMD.

.dockerignore is like .gitignore - it tells docker what files it should ignore when copying the _docker context_ into the container.

We learn about laying in the Docker file and how to keep our builds fast by organizing what commands change and how they change.

## Chapter 4.

Focus on Docker compose. Everything we've done can be wrapped up in a docker-compose file. This configuration will allow us to easily work with a complex system.

We no longer put everything on one server. By organizing our application in containers, we can appropriatly scale the services by need. Giving us greater efficency in our spending.

Docker compose gives us the same options as docker run - we just have to specify which container to perform the oeprations on.

## Chapter 5.

We use a docker-container command to start a redis cli.

`docker-compose run --rm redis redis-cli -h redis`
  rm: remove container after running
  redis: name of service to run
  redis-cli: In the redis container, start the cli
  h: host name. We use `redis` because docker-compose has creaetd a network, with DNS, using our configuration.
       `redis` will point to the ip of our redis container

This means the `docker-compose run --rm service` is the meat and potatoes of what I'm running. So I can do `docker-compose run --rm redis redis-cli --help` to fetch the flags and see what 'h' means.

I'm not using the `it` flags here to maintain my session. Remember when we looked at the CMD syntax? We learned that docker will run a single command and exit. Here, the command is a cli, so I stay in that sesson. When I exist the cli it will quit the docker container (and remove it) for me).

This also means I can enter the rails console with `docker-compose run --rm web rails c`.

Back to the original command, this is interesting because we're running a new `redis` container and connecting to the running instance in the docker-container network.

If we used `exec` instead, we would be running the command in the existing container.

Next we generate a new controller for our rails project `docker-container exec web bin/rails g controller welcome index`. It is surreal to see the container generate the files in the container - but also in the current locally directory. This is because we've mounted the file directory. I believe this is happening becuase the docker managment layer is synchronizing the file system between me and the container automatically.

This is a little head spinning that I"m using software in the container, not my local machine, to run a process, generate output, and have it locally.

At the end of the chapter it's suggested we do not need tools like Foreman. With Docker Compose we've been able to run mulitple services, without installing ruby, rails, or redis, and maintain them.

## Chapter 6.

This chapter overlapped the last one and included ways to
* extract and dry up docker-compose configs
* decoupled database container from data we wanted to persist

This chapter also introduces Volumes. Buckets to store data that's managed by docker.

## Chapter 7.

This chapter has been frustrating with the changes to the technology. I was able to figure out how to install `yarn` and the dockerfile at that point is commit f90c52212510506dc667ab3bea4a73c1ff5d788a.

This is the reason I had to backtrack on chapter 2/3 where I had Rails 6 installed and needed to start over with Rails 5 due to the dependancy on yarn.

I was able to finish this chapter by restarting at the beginning a few times. I'm happy it's over. All the pain of this book has been installing yarn. I have nothing more to say about this chapter so yay! Moving on =D

## Chapter 8.

Setting up and running RSpec is straightforward and could have been assumed by the reader now.
1. Add RSpec gem to Gemfile
2. `docker-compose stop web`
3. `docker-compose build web`
4. `docker-compose up -d --force-recreate web`

Running rspec uses `exec` as we want to run the commands in the currently running container

`docker-compose exec web bin/rails spec`

# Debugging

To debug we need to have an interactive session that breaks and allows us to bind context. That isn't as available while `web` is running in it's own container (I'm sure someone has made a workaround).

The solution is to simply use `run`. I was able to debug a test script by placing a `byebug` trace point and running

`docker-compose run web rspec spec/system/`

When running the web we do

`docker-compose run --service-ports web` : --service-ports maps to the ports specified in docker-compose.yml.

## Chapter 9.

In this chapter we learn how to manage our Gem installs in a docker volumn. This has the benefit of allowing bundler to actually manage our gems instead of installing it over and over.

Like Rob says, this technique adds more complexity and requires devs to have a higher skill in Docker. But it is a very attractive solution. It speeds up deployments and allows the tools to fit the problems space they were designed for.

## Chapter 10.

Here we learn to use ENTRYPOINTS to have a BEGIN script in running our Docker Containers. We use it to fix a pesky bug where the server.pid file sometimes sticks around.

This chapter concludes our development with Docker and we move on to using Docker in Production.

I've really enjoyed this book so far. It did have it's fair share of head aches but I know have the confidence and motivation to squeeze docker into my dev workflow.

## Chapter 11. - General overview of the rest of the book

## Chapter 12. Preparing for Production

It's been nice to get a break from 5 year old configs! This chapter was straightforward and introduces us to the Docker Registry.

I hope we see more of the registry. I think it will be key to making our CI pipelines faster. Instead of setting up a testing environment for every run we should build an image, keep it current, and just re-use it.
