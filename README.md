# Namaste Nepal
This project was developed to be a social media for Nepalese people, inspired by Reddit, Twitter and Facebook. 

The frontend and backend are separate by design as a part of long term development.

The project was dropped at the end of 2019, and since then, many dependency libraries might have broken. So, the app may not work properly as intended. I have tried to wrap the application into docker-compose containers as to easy the hassle to manage multiple services required to setup the system.

However, steps to run the project:
- Make sure make, docker and docker-compose is installed.
- git clone --recurse-submodules # as the frontend and backend are separate git projects managed in submodules
- make setup
- make up

Hopefully that would do the trick. There may be some issues while doing this such as no .env file found and likewise. They may be easy to solve.