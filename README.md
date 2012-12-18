# FollowerMaze Server
## Usage
`cd` into the project directory and run `ruby app.rb`.  
To run the tests call `bundle` and `rspec` (test with the sample client app is included in the test suite).

## Dependencies
As required, no dependencies besides Ruby MRI 1.9.3. Although, for better performance I would use a minimum-heap structure from the `algorithms` gem, in place of the standard `Array`, for storing a sorted list of events.
