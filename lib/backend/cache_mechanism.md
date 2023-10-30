# Firebase Data Flow with Caching in Flutter

This document illustrates the flow of data from Firebase to the display, with a caching mechanism implemented using Hive.

## Data Flow Diagram

```plaintext
                                                                      
1. Load Data Triggered (e.g., App Launch, User Scroll)                 
               |                                                        
               |                                                        
2. Check Cache for Existing Data                                       
               |                                                        
               |                                                        
       +-------+-------+                                                
       |               |                                                
3a. Cached Data       3b. No Cached Data                               
   Available            Available                                       
       |               |                                                
       |               |                                                
4a. Load Cached      4b. Request Data                                  
   Data from Hive       from Firebase                                  
       |               |                                                
       |               |                                                
5a. Convert Cached   5b. Convert Firestore                             
   Data to JobRecord    Documents to JobRecord                          
   Objects              Objects                                         
       |               |                                                
       |               |                                                
       |        +------+-----+                                          
       |        |            |                                          
6a. Display   6b. Cache Data 6c. Display                               
   Cached Data    in Hive      Fetched Data                             
       |            |            |                                      
       |            |            |                                      
       +------------+------------+                                      
                      |                                                  
                      |                                                  
                  7. Close Hive                                         
                      Box                                               
                      |                                                  
                      |                                                  
                      v                                                  
```

## Data Flow Description
1. Load Data Triggered: Triggered by various events such as app launch, user action, or reaching the end of a scrollable list.

2. Check Cache for Existing Data: Look in the Hive box to see if there is any cached data.

3. Cached Data Available 
    (3a): If cached data is available, proceed to step 4a. No Cached Data Available 
    (3b): If no cached data is available, proceed to step 4b.

4. Load Cached Data from Hive 
    (4a): Retrieve the cached data from Hive. Request Data from Firebase 
    (4b): If there is no cached data, request data from Firebase.

5. Convert Cached Data to JobRecord Objects 
    (5a): Convert the cached data from Hive to JobRecord objects. Convert Firestore Documents to JobRecord Objects 
    (5b): Convert the data fetched from Firebase to JobRecord objects.

6. Display Cached Data 
    (6a): Display the cached data on the screen. Cache Data in Hive 
    (6b): Cache the fetched data in Hive for future use. Display Fetched Data 
    (6c): Display the fetched data on the screen.

7. Close Hive Box: Close the Hive box to release resources.
