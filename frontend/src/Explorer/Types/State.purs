module Explorer.Types.State where

import Prelude (class Eq, class Ord, class Show)
import Control.Monad.Eff.Exception (Error)
import Control.SocketIO.Client (Socket)
import Data.Generic (class Generic, gEq, gShow)
import Data.Maybe (Maybe)
import Data.Newtype (class Newtype)
import Data.Tuple (Tuple)
import Explorer.I18n.Lang (Language)
import Explorer.Routes (Route)
import Network.RemoteData (RemoteData)
import Pos.Explorer.Socket.Methods (Subscription)
import Pos.Explorer.Web.ClientTypes (CAddress, CAddressSummary, CBlockEntry, CBlockSummary, CTxBrief, CTxEntry, CTxSummary)
import Data.DateTime (DateTime)

-- Add all State types here to generate lenses from it

type State =
    { lang :: Language
    , route :: Route
    , socket :: SocketState
    , viewStates :: ViewStates
    , latestBlocks :: RemoteData Error CBlockEntries
    , initialBlocksRequested :: Boolean
    , handleLatestBlocksSocketResult :: Boolean
    , initialTxsRequested :: Boolean
    , handleLatestTxsSocketResult :: Boolean
    , currentBlockSummary :: Maybe CBlockSummary
    , currentBlockTxs :: Maybe CTxBriefs
    , currentTxSummary :: RemoteData Error CTxSummary
    , latestTransactions :: CTxEntries
    , currentCAddress :: CAddress
    , currentAddressSummary :: RemoteData Error CAddressSummary
    , currentBlocksResult :: RemoteData Error CBlockEntries
    , errors :: Errors
    , loading :: Boolean
    , now :: DateTime
    }

data Search
    = SearchAddress
    | SearchTx
    | SearchTime

derive instance gSearch :: Generic Search
instance showSearch :: Show Search where
    show = gShow
derive instance eqSearch :: Eq Search

type SearchEpochSlotQuery = Tuple (Maybe Int) (Maybe Int)

type SocketState =
    { connected :: Boolean
    , connection :: Maybe Socket
    , subscriptions :: Array SocketSubscription
    }

data DashboardAPICode = Curl | Node | JQuery
derive instance eqDashboardAPICode :: Eq DashboardAPICode
derive instance ordDashboardAPICode :: Ord DashboardAPICode

-- Wrapper of 'Subscription' built by 'purescript bridge'
-- needed to derive generice instances of it
newtype SocketSubscription = SocketSubscription Subscription
derive instance gSocketSubscription :: Generic SocketSubscription
derive instance newtypeSocketSubscription :: Newtype SocketSubscription _
instance eqSocketSubscription :: Eq SocketSubscription where
  eq = gEq

type CBlockEntries = Array CBlockEntry
type CTxEntries = Array CTxEntry
type CTxBriefs = Array CTxBrief

type Errors = Array String

type ViewStates =
    { globalViewState :: GlobalViewState
    , dashboard :: DashboardViewState
    , addressDetail :: AddressDetailViewState
    , blockDetail :: BlockDetailViewState
    , blocksViewState :: BlocksViewState
    }

type GlobalViewState =
    { gViewMobileMenuOpenend :: Boolean
    , gViewTitle :: String
    , gViewSearchInputFocused :: Boolean
    , gViewSelectedSearch :: Search
    , gViewSearchQuery :: String
    , gViewSearchTimeQuery :: SearchEpochSlotQuery
    }

type DashboardViewState =
    { dbViewBlocksExpanded :: Boolean
    , dbViewBlockPagination :: Int
    , dbViewNewBlockPagination :: Int
    , dbViewBlockPaginationEditable :: Boolean
    , dbViewTxsExpanded :: Boolean
    , dbViewSelectedApiCode :: DashboardAPICode
    }

type BlockDetailViewState =
    { blockTxPagination :: Int
    , blockTxPaginationEditable :: Boolean
    }

type AddressDetailViewState =
    { addressTxPagination :: Int
    , addressTxPaginationEditable :: Boolean
    }

type BlocksViewState =
    { blsViewPagination :: Int
    , blsViewPaginationEditable :: Boolean
    }

-- TODO (jk) CCurrency should be generated by purescript-bridge later
data CCurrency
    = ADA
    | BTC
    | USD
