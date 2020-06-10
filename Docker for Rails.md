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
