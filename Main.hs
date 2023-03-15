module Main where

import Control.Concurrent.Async
import Control.Concurrent.STM
import Control.Monad
import Numeric.Natural

main :: IO ()
main = do
    queue <- newTBQueueIO 1000010
    withAsync (readQueue queue) $ \_ -> mapConcurrently_ (replicateM_ 100000 . enqueue queue) "0123456789"
        
readQueue :: TBQueue a -> IO ()
readQueue queue = forever . atomically $ readTBQueue queue

enqueue :: TBQueue a -> a -> IO Natural
enqueue queue a = atomically $ do
    writeTBQueue queue a
    lengthTBQueue queue
