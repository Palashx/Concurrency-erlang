-module (calling).

-export([messageReceiver/1]). 

messageReceiver(Key) ->
			receive
			  		{"Message sent to receiver", Friend, Process_Name,Timestamp} ->
			  			masterProcess ! {"Message sent to receiver", Friend, Process_Name, Timestamp},
			  			masterProcess ! {"Message sent by receiver", Friend, Process_Name, Timestamp},
			  			messageReceiver(Key)		
			after 1500 ->    	
			  			io:fwrite("\nProcess ~w has received no calls for 1.5 second, ending...\n",[Key])
		    end.

