/*********************************************
 * OPL 12.7.0.0 Model
 * Author: Marius
 * Creation Date: 26.02.2017 at 21:57:25
 *********************************************/

// Indices
int COUNT_VIDEOS = ...;
int COUNT_ENDPOINTS = ...;
int COUNT_CACHES = ...;
range Videos = 0..COUNT_VIDEOS;
range Endpoints = 0..COUNT_ENDPOINTS;
range Caches = 0..COUNT_CACHES;

// Input
int videoSize[Videos] = ...;
int cacheSize = ...;
int latencyCaches[Endpoints][Caches] = ...;
int latencyDatacenter[Endpoints] = ...;
int request[Endpoints][Videos] = ...;

// Decision Variables
// video present on Cache and Streamed from Endpoint
dvar boolean x[Videos][Caches][Endpoints];

// Objective Function
dexpr float sumRequests = sum(e in Endpoints) sum (v in Videos) request[e][v];
dexpr float timeSaved = sum(v in Videos) sum(c in Caches) sum(e in Endpoints) x[v][c][e] * request[e][v] * (latencyDatacenter[e] - latencyCaches[e][c]);

// maximize avg time saved
maximize (timeSaved / sumRequests)*1000;

// Constraints
subject to {
	// limit videos per cache by size
	forall(c in Caches){
		C1: sum (v in Videos) sum(e in Endpoints) x[v][c][e] * videoSize[v] <= cacheSize;
	}
	
	// video can only be streamed from maximum one cache
	forall(v in Videos){
			sum(c in Caches)sum(e in Endpoints) x[v][c][e] <= 1;		
	}	
}