{-# LANGUAGE OverloadedStrings, LambdaCase, DeriveGeneric,
  RecordWildCards #-}

module Main where

import Data.Aeson
import qualified Data.ByteString.Lazy as BS
import Data.Maybe
import Data.Monoid
import Data.Text.Lazy as T
import Data.YAML.Aeson as YA
import GHC.Generics
import System.Directory
import System.FilePath
import System.IO
import Text.RegexPR
import Web.Scotty

data Config =
  MkConfig
    { patterns :: [(String, String)]
    , port :: Int
    }
  deriving (Generic, Show)

instance FromJSON Config

main :: IO ()
main = do
  hd <- getHomeDirectory
  let configfile = hd </> ".searchserver"
  config <- YA.decode1 <$> BS.readFile configfile
  case config of
    Left (p, s) ->
      putStrLn $ "Error parsing config file at position " ++ show p ++ ": " ++ s
    Right MkConfig {..} ->
      scotty port $
      get "/" $ do
        qps <- param "q"
        let q = unpack $ strip $ pack qps
        let url = firstSub q patterns
        redirect $ strip $ T.replace "+" "%2B" $ pack url

firstSub :: String -> [([Char], String)] -> String
firstSub str pats =
  fromMaybe "https://www.haskell.org/" $
  getFirst $ mconcat $ fmap (First . trySub str) pats

trySub :: String -> ([Char], String) -> Maybe String
trySub str (pat, rep)
  | Just _ <- matchRegexPR (complete pat) str = Just $ subRegexPR pat rep str
  | otherwise = Nothing

complete :: [Char] -> [Char]
complete str = "^" ++ str ++ "$"
