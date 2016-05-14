{-# OPTIONS_GHC -fno-warn-unticked-promoted-constructors #-}

{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Control.Monad.Ether.TagAttach
  ( K_TAG_ATTACH(..)
  , TagAttachT
  , tagAttach
  ) where

import Control.Monad.Trans.Identity

import Control.Monad.Ether.Reader.Class
import Control.Monad.Ether.State.Class
import Control.Monad.Ether.Except.Class
import Control.Monad.Ether.Writer.Class

import Control.Monad.Ether.Reader as A
import Control.Monad.Ether.State.Common as A
import Control.Monad.Ether.Except as A
import Control.Monad.Ether.Writer as A

import qualified Control.Monad.Reader.Class  as Class
import qualified Control.Monad.State.Class   as Class
import qualified Control.Monad.Writer.Class  as Class
import qualified Control.Monad.Error.Class   as Class

import Control.Monad.Trans.Ether.Dispatch

-- | Encode type-level information for 'tagAttach'.
data K_TAG_ATTACH t = TAG_ATTACH t

type TagAttachT t = Dispatch (TAG_ATTACH t) IdentityT

-- | Attach a tag to untagged transformers.
tagAttach :: forall tag m a . TagAttachT tag m a -> m a
tagAttach = runIdentityT . unpack

instance
    ( MonadReader tag r m, trans ~ IdentityT
    ) => Class.MonadReader r (Dispatch (TAG_ATTACH tag) trans m)
  where
    ask   = A.ask @tag
    local = A.local @tag

instance
    ( MonadState tag s m, trans ~ IdentityT
    ) => Class.MonadState s (Dispatch (TAG_ATTACH tag) trans m)
  where
    get = A.get @tag
    put = A.put @tag

instance
    ( MonadExcept tag e m, trans ~ IdentityT
    ) => Class.MonadError e (Dispatch (TAG_ATTACH tag) trans m)
  where
    throwError = A.throw @tag
    catchError = A.catch @tag

instance
    ( MonadWriter tag w m, trans ~ IdentityT
    ) => Class.MonadWriter w (Dispatch (TAG_ATTACH tag) trans m)
  where
    writer = A.writer @tag
    tell   = A.tell @tag
    listen = A.listen @tag
    pass   = A.pass @tag
