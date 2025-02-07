lightning-bkpr-listaccountevents -- Command for listing recorded bookkeeping events
=============================================================================

SYNOPSIS
--------

**bkpr-listaccountevents** [\*account\*]

DESCRIPTION
-----------

The **bkpr-listaccountevents** RPC command is a list of all bookkeeping events that have been recorded for this node.

If the optional parameter **account** is set, we only emit events for the
specified account, if exists.

Note that the type **onchain_fees** that are emitted are of opposite credit/debit than as they appear in **listincome**, as **listincome** shows all events from the perspective of the node, whereas **listaccountevents** just dumps the event data as we've got it. Onchain fees are updated/recorded as we get more information about input and output spends -- the total onchain fees that were recorded for a transaction for an account can be found by summing all onchain fee events and taking the difference between the **credit_msat** and **debit_msat** for these events. We do this so that successive calls to **listaccountevents** always
produce the same list of events -- no previously emitted event will be
subsequently updated, rather we add a new event to the list.


RETURN VALUE
------------

[comment]: # (GENERATE-FROM-SCHEMA-START)
On success, an object containing **events** is returned.  It is an array of objects, where each object contains:
- **account** (string): The account name. If the account is a channel, the channel_id
- **type** (string): Coin movement type (one of "onchain_fee", "chain", "channel")
- **tag** (string): Description of movement
- **credit_msat** (msat): Amount credited
- **debit_msat** (msat): Amount debited
- **currency** (string): human-readable bech32 part for this coin type
- **timestamp** (u32): Timestamp this event was recorded by the node. For consolidated events such as onchain_fees, the most recent timestamp

If **type** is "chain":
  - **outpoint** (string): The txid:outnum for this event
  - **blockheight** (u32): For chain events, blockheight this occured at
  - **origin** (string, optional): The account this movement originated from
  - **payment_id** (hex, optional): lightning payment identifier. For an htlc, this will be the preimage.
  - **txid** (txid, optional): The txid of the transaction that created this event
  - **description** (string, optional): The description of this event

If **type** is "onchain_fee":
  - **txid** (txid): The txid of the transaction that created this event

If **type** is "channel":
  - **fees_msat** (msat, optional): Amount paid in fees
  - **is_rebalance** (boolean, optional): Is this payment part of a rebalance
  - **payment_id** (hex, optional): lightning payment identifier. For an htlc, this will be the preimage.
  - **part_id** (u32, optional): Counter for multi-part payments

[comment]: # (GENERATE-FROM-SCHEMA-END)

AUTHOR
------

niftynei <niftynei@gmail.com> is mainly responsible.

SEE ALSO
--------

lightning-bkpr-listincome(7), lightning-listfunds(7),
lightning-bkpr-listbalances(7), lightning-bkpr-channelsapy(7).

RESOURCES
---------

Main web site: <https://github.com/ElementsProject/lightning>

[comment]: # ( SHA256STAMP:8568188808cb649d7182ffb628950b93b18406a0498b5b6768371bc94375e258)
