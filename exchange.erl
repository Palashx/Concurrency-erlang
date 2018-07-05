-module (exchange).

-import(lists,[nth/2]).
-import(lists,[nth/3]).
-import(lists,[append/2]). 
-import(string,[concat/2]). 

-export([start/0, spawnProcess/2, menufunc/2, mapIterate/1, masterMessageReceiver/0, messageCallee/2, myloop/3, 
	     timeStampFunction/0, messageProcesses/2]). 

start() ->
	
%   Register master
	register(masterProcess, self()),
	ExtractTuple = file:consult("calls.txt"),
	TupleToList = tuple_to_list(ExtractTuple),
	CalleList = nth(2,TupleToList),
    MapOfData = maps:from_list(CalleList),
    io:fwrite("** Calls to be made **\n"),
%   Making a list of processes to be made
	ListofProcesses = maps:keys(MapOfData),
	[menufunc(Key,MapOfData) || Key <- ListofProcesses],
    [spawnProcess(Key,MapOfData) || Key <- ListofProcesses],
    io:fwrite("\n"),
    mapIterate(MapOfData),
    masterMessageReceiver().

%print menu
menufunc(Key,MapOfData) ->   
	 
	 io:fwrite("~w : ~w \n", [Key, maps:get(Key,MapOfData)]).
	 
% sending message to processes
messageProcesses(Callee, CurrentProcess)->	
			
		Callee ! {"Message sent to receiver", Callee, CurrentProcess, timeStampFunction()}.

% sending message to all the receivers
messageCallee(CurrentProcess,MapOfData) ->
		
       	  ReceiverList = maps:get(CurrentProcess,MapOfData),
       	  % for each for each receiver
		  [messageProcesses(Callee, CurrentProcess) || Callee <- ReceiverList].

spawnProcess(Key,MapOfData) ->
		 
		 ReceiverList = maps:get(Key,MapOfData),
%        Spawing a thread for each caller
		 Pid = spawn(calling, messageReceiver, [Key]),
		 register(Key, Pid).
	
mapIterate(MapOfData) ->
		   
		   ListofProcesses = maps:keys(MapOfData),
		   myloop(length(ListofProcesses),ListofProcesses,MapOfData).    

% remove console output
myloop(0,ListofProcesses,MapOfData) -> 
	    donothing;

myloop(N,ListofProcesses,MapOfData) ->
	
		Key = lists:nth(N,ListofProcesses),
		messageCallee(Key,MapOfData),
		myloop(N-1,ListofProcesses,MapOfData).

%masterreceiver
masterMessageReceiver() ->

		receive
				{"Message sent to receiver", Callee, CurrentProcess,Timestamp} ->
					io:fwrite("~s Received intro message From ~w ~w \n",[Callee, CurrentProcess,Timestamp]),
					masterMessageReceiver();
				{"Message sent by receiver",CurrentProcess,Callee,Timestamp} ->
					io:fwrite("~s Received reply From ~w ~w \n",[Callee,CurrentProcess,Timestamp]),
					masterMessageReceiver()

		after 2000 -> io:fwrite("\nMaster has received no replies for 2 seconds, ending...")		
		end.

%Calculate timestamp
 timeStampFunction() ->
		  
	  TimeStampData = erlang:now(),
	  ListOfTimeStamp = tuple_to_list(TimeStampData),
	  Timestamp = nth(3,ListOfTimeStamp).


	