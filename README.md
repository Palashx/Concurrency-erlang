# Concurrency-erlang

This was the final project for the course COMP6411 Comparative study of programming language.
Main task of the project was to create a dynamic number of processes, and to pass messages between these processes.
We were given a text file which has a list of people, and where each person communicates with other people. 

Here the master process reads data from a text file. And it creates other processes. One process is generated for a each person. Depending on the data in text file each process sends a message to other people, this message is in the form of a time stamp. So there are sender reciever pairs. After receiveing a message from the sender receiver sends a message to the master process that communication has taken place and masters prints out on the erlang console with the details of the communication (name of the sender, name of the receiver, timestamp of when the message was sent. 
