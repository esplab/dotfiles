#!/bin/bash

skill -TERM -u $(whoami)&
sleep 5 &&
skill -KILL -u $(whoami) &&
sync