Chapter 1.

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

Chapter 2.

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


Chapter 3.

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

Chapter 4.

Focus on Docker compose. Everything we've done can be wrapped up in a docker-compose file. This configuration will allow us to easily work with a complex system.

We no longer put everything on one server. By organizing our application in containers, we can appropriatly scale the services by need. Giving us greater efficency in our spending.

Docker compose gives us the same options as docker run - we just have to specify which container to perform the oeprations on.

Chapter 5.

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
