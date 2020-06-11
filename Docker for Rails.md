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
