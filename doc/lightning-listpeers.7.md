# lightning-listpeers -- Command returning data on connected lightning nodes

## SYNOPSIS

**listpeers** [_id_] [_level_]

## DESCRIPTION

The **listpeers** RPC command returns data on nodes that are connected or are
not connected but have open channels with this node.

Once a connection to another lightning node has been established, using the
**connect** command, data on the node can be returned using **listpeers** and
the _id_ that was used with the **connect** command.

If no _id_ is supplied, then data on all lightning nodes that are connected, or
not connected but have open channels with this node, are returned.

Supplying _id_ will filter the results to only return data on a node with a
matching _id_, if one exists.

Supplying _level_ will show log entries related to that peer at the given log
level. Valid log levels are "io", "debug", "info", and "unusual".

If a channel is open with a node and the connection has been lost, then the node
will still appear in the output of the command and the value of the _connected_
attribute of the node will be "false".

The channel will remain open for a set blocktime, after which if the connection
has not been re-established, the channel will close and the node will no longer
appear in the command output.

## RETURN VALUE

[comment]: # (GENERATE-FROM-SCHEMA-START)

On success, an object containing **peers** is returned. It is an array of
objects, where each object contains:

- **id** (pubkey): the public key of the peer
- **connected** (boolean): True if the peer is currently connected
- **num\_channels** (u32): The number of channels the peer has with this node
  _(added v23.02)_
- **log** (array of objects, optional): if _level_ is specified, logs for this
  peer:
  - **type** (string) (one of "SKIPPED", "BROKEN", "UNUSUAL", "INFO", "DEBUG",
    "IO\_IN", "IO\_OUT")

  If **type** is "SKIPPED":

  - **num\_skipped** (u32): number of deleted/omitted entries

  If **type** is "BROKEN", "UNUSUAL", "INFO" or "DEBUG":

  - **time** (string): UNIX timestamp with 9 decimal places
  - **source** (string): The particular logbook this was found in
  - **log** (string): The actual log message
  - **node\_id** (pubkey): The peer this is associated with

  If **type** is "IO\_IN" or "IO\_OUT":

  - **time** (string): UNIX timestamp with 9 decimal places
  - **source** (string): The particular logbook this was found in
  - **log** (string): The actual log message
  - **node\_id** (pubkey): The peer this is associated with
  - **data** (hex): The IO which occurred
- **channels** (array of objects, optional) **deprecated, removal in v23.11**:
  - **state** (string): the channel state, in particular "CHANNELD\_NORMAL"
    means the channel can be used normally (one of "OPENINGD",
    "CHANNELD\_AWAITING\_LOCKIN", "CHANNELD\_NORMAL",
    "CHANNELD\_SHUTTING\_DOWN", "CLOSINGD\_SIGEXCHANGE", "CLOSINGD\_COMPLETE",
    "AWAITING\_UNILATERAL", "FUNDING\_SPEND\_SEEN", "ONCHAIN",
    "DUALOPEND\_OPEN\_INIT", "DUALOPEND\_AWAITING\_LOCKIN",
    "DUALOPEND\_OPEN\_COMMITTED", "DUALOPEND\_OPEN\_COMMIT\_READY")
  - **opener** (string): Who initiated the channel (one of "local", "remote")
  - **features** (array of strings):
    - BOLT #9 features which apply to this channel (one of
      "option\_static\_remotekey", "option\_anchor\_outputs",
      "option\_scid\_alias", "option\_zeroconf")
  - **scratch\_txid** (txid, optional): The txid we would use if we went onchain
    now
  - **feerate** (object, optional): Feerates for the current tx:
    - **perkw** (u32): Feerate per 1000 weight (i.e kSipa)
    - **perkb** (u32): Feerate per 1000 virtual bytes
  - **owner** (string, optional): The current subdaemon controlling this
    connection
  - **short\_channel\_id** (short\_channel\_id, optional): The
    short\_channel\_id (once locked in)
  - **channel\_id** (hash, optional): The full channel\_id (always 64
    characters)
  - **funding\_txid** (txid, optional): ID of the funding transaction
  - **funding\_outnum** (u32, optional): The 0-based output number of the
    funding transaction which opens the channel
  - **initial\_feerate** (string, optional): For inflight opens, the first
    feerate used to initiate the channel open
  - **last\_feerate** (string, optional): For inflight opens, the most recent
    feerate used on the channel open
  - **next\_feerate** (string, optional): For inflight opens, the next feerate
    we'll use for the channel open
  - **next\_fee\_step** (u32, optional): For inflight opens, the next feerate
    step we'll use for the channel open
  - **inflight** (array of objects, optional): Current candidate funding
    transactions (only for dual-funding):
    - **funding\_txid** (txid): ID of the funding transaction
    - **funding\_outnum** (u32): The 0-based output number of the funding
      transaction which opens the channel
    - **feerate** (string): The feerate for this funding transaction in
      per-1000-weight, with "kpw" appended
    - **total\_funding\_msat** (msat): total amount in the channel
    - **our\_funding\_msat** (msat): amount we have in the channel
    - **splice\_amount** (integer): The amouont of sats we're splicing in or out
      _(added v23.08)_
    - **scratch\_txid** (txid): The commitment transaction txid we would use if
      we went onchain now
  - **close\_to** (hex, optional): scriptPubkey which we have to close to if we
    mutual close
  - **private** (boolean, optional): if True, we will not announce this channel
  - **closer** (string, optional): Who initiated the channel close (one of
    "local", "remote")
  - **funding** (object, optional):
    - **local\_funds\_msat** (msat): Amount of channel we funded
    - **remote\_funds\_msat** (msat): Amount of channel they funded
    - **pushed\_msat** (msat, optional): Amount pushed from opener to peer
    - **fee\_paid\_msat** (msat, optional): Amount we paid peer at open
    - **fee\_rcvd\_msat** (msat, optional): Amount we were paid by peer at open
  - **to\_us\_msat** (msat, optional): how much of channel is owed to us
  - **min\_to\_us\_msat** (msat, optional): least amount owed to us ever
  - **max\_to\_us\_msat** (msat, optional): most amount owed to us ever
  - **total\_msat** (msat, optional): total amount in the channel
  - **fee\_base\_msat** (msat, optional): amount we charge to use the channel
  - **fee\_proportional\_millionths** (u32, optional): amount we charge to use
    the channel in parts-per-million
  - **dust\_limit\_msat** (msat, optional): minimum amount for an output on the
    channel transactions
  - **max\_total\_htlc\_in\_msat** (msat, optional): max amount accept in a
    single payment
  - **their\_reserve\_msat** (msat, optional): minimum we insist they keep in
    channel
  - **our\_reserve\_msat** (msat, optional): minimum they insist we keep in
    channel
  - **spendable\_msat** (msat, optional): total we could send through channel
  - **receivable\_msat** (msat, optional): total peer could send through channel
  - **minimum\_htlc\_in\_msat** (msat, optional): the minimum amount HTLC we
    accept
  - **minimum\_htlc\_out\_msat** (msat, optional): the minimum amount HTLC we
    will send
  - **maximum\_htlc\_out\_msat** (msat, optional): the maximum amount HTLC we
    will send
  - **their\_to\_self\_delay** (u32, optional): the number of blocks before they
    can take their funds if they unilateral close
  - **our\_to\_self\_delay** (u32, optional): the number of blocks before we can
    take our funds if we unilateral close
  - **max\_accepted\_htlcs** (u32, optional): Maximum number of incoming HTLC we
    will accept at once
  - **alias** (object, optional):
    - **local** (short\_channel\_id, optional): An alias assigned by this node
      to this channel, used for outgoing payments
    - **remote** (short\_channel\_id, optional): An alias assigned by the remote
      node to this channel, usable in routehints and invoices
  - **state\_changes** (array of objects, optional): Prior state changes:
    - **timestamp** (string): UTC timestamp of form YYYY-mm-ddTHH:MM:SS.%03dZ
    - **old\_state** (string): Previous state (one of "OPENINGD",
      "CHANNELD\_AWAITING\_LOCKIN", "CHANNELD\_NORMAL",
      "CHANNELD\_SHUTTING\_DOWN", "CLOSINGD\_SIGEXCHANGE", "CLOSINGD\_COMPLETE",
      "AWAITING\_UNILATERAL", "FUNDING\_SPEND\_SEEN", "ONCHAIN",
      "DUALOPEND\_OPEN\_INIT", "DUALOPEND\_AWAITING\_LOCKIN",
      "DUALOPEND\_OPEN\_COMMITTED", "DUALOPEND\_OPEN\_COMMIT\_READY")
    - **new\_state** (string): New state (one of "OPENINGD",
      "CHANNELD\_AWAITING\_LOCKIN", "CHANNELD\_NORMAL",
      "CHANNELD\_SHUTTING\_DOWN", "CLOSINGD\_SIGEXCHANGE", "CLOSINGD\_COMPLETE",
      "AWAITING\_UNILATERAL", "FUNDING\_SPEND\_SEEN", "ONCHAIN",
      "DUALOPEND\_OPEN\_INIT", "DUALOPEND\_AWAITING\_LOCKIN",
      "DUALOPEND\_OPEN\_COMMITTED", "DUALOPEND\_OPEN\_COMMIT\_READY")
    - **cause** (string): What caused the change (one of "unknown", "local",
      "user", "remote", "protocol", "onchain")
    - **message** (string): Human-readable explanation
  - **status** (array of strings, optional):
    - Billboard log of significant changes
  - **in\_payments\_offered** (u64, optional): Number of incoming payment
    attempts
  - **in\_offered\_msat** (msat, optional): Total amount of incoming payment
    attempts
  - **in\_payments\_fulfilled** (u64, optional): Number of successful incoming
    payment attempts
  - **in\_fulfilled\_msat** (msat, optional): Total amount of successful
    incoming payment attempts
  - **out\_payments\_offered** (u64, optional): Number of outgoing payment
    attempts
  - **out\_offered\_msat** (msat, optional): Total amount of outgoing payment
    attempts
  - **out\_payments\_fulfilled** (u64, optional): Number of successful outgoing
    payment attempts
  - **out\_fulfilled\_msat** (msat, optional): Total amount of successful
    outgoing payment attempts
  - **htlcs** (array of objects, optional): current HTLCs in this channel:
    - **direction** (string): Whether it came from peer, or is going to peer
      (one of "in", "out")
    - **id** (u64): Unique ID for this htlc on this channel in this direction
    - **amount\_msat** (msat): Amount send/received for this HTLC
    - **expiry** (u32): Block this HTLC expires at
    - **payment\_hash** (hash): the hash of the payment\_preimage which will
      prove payment (always 64 characters)
    - **local\_trimmed** (boolean, optional): if this is too small to enforce
      onchain (always _true_)
    - **status** (string, optional): set if this HTLC is currently waiting on a
      hook (and shows what plugin)

    If **direction** is "out":

    - **state** (string): Status of the HTLC (one of "SENT\_ADD\_HTLC",
      "SENT\_ADD\_COMMIT", "RCVD\_ADD\_REVOCATION", "RCVD\_ADD\_ACK\_COMMIT",
      "SENT\_ADD\_ACK\_REVOCATION", "RCVD\_REMOVE\_HTLC",
      "RCVD\_REMOVE\_COMMIT", "SENT\_REMOVE\_REVOCATION",
      "SENT\_REMOVE\_ACK\_COMMIT", "RCVD\_REMOVE\_ACK\_REVOCATION")

    If **direction** is "in":

    - **state** (string): Status of the HTLC (one of "RCVD\_ADD\_HTLC",
      "RCVD\_ADD\_COMMIT", "SENT\_ADD\_REVOCATION", "SENT\_ADD\_ACK\_COMMIT",
      "RCVD\_ADD\_ACK\_REVOCATION", "SENT\_REMOVE\_HTLC",
      "SENT\_REMOVE\_COMMIT", "RCVD\_REMOVE\_REVOCATION",
      "RCVD\_REMOVE\_ACK\_COMMIT", "SENT\_REMOVE\_ACK\_REVOCATION")
  - **last_update_tx** (string, optional): latest signed and finalized update
    transaction bound to latest state output
  - **last_settle_tx** (string, optional): latest signed and finalized settle
    transaction bound to last_update_tx state outpoint
  - **unbound_update_tx** (string, optional): latest unfinalized update
    transaction
  - **unbound_settle_tx** (string, optional): latest unfinalized settle
    transaction
  - **last_committed_settle_tx** (string, optional): latest finalized settle
    transaction bound to a committed-but-not-complete update transaction

  If **close\_to** is present:

  - **close\_to\_addr** (string, optional): The bitcoin address we will close to

  If **scratch\_txid** is present:

  - **last\_tx\_fee\_msat** (msat): fee attached to this the current tx

  If **short\_channel\_id** is present:

  - **direction** (u32): 0 if we're the lesser node\_id, 1 if we're the greater

  If **inflight** is present:

  - **initial\_feerate** (string): The feerate for the initial funding
    transaction in per-1000-weight, with "kpw" appended
  - **last\_feerate** (string): The feerate for the latest funding transaction
    in per-1000-weight, with "kpw" appended
  - **next\_feerate** (string): The minimum feerate for the next funding
    transaction in per-1000-weight, with "kpw" appended

If **connected** is _true_:

- **netaddr** (array of strings): A single entry array:
  - address, e.g. 1.2.3.4:1234
- **features** (hex): bitmap of BOLT #9 features from peer's INIT message
- **remote\_addr** (string, optional): The public IPv4/6 address the peer sees
  us from, e.g. 1.2.3.4:1234

[comment]: # (GENERATE-FROM-SCHEMA-END)

On success, an object with a "peers" key is returned containing a list of 0 or
more objects.

Each object in the list contains the following data:

- _id_ : The unique id of the peer
- _connected_ : A boolean value showing the connection status
- _netaddr_ : A list of network addresses the node is listening on
- _features_ : Bit flags showing supported features (BOLT \#9)
- _channels_ : An array of objects describing channels with the peer.
- _log_ : Only present if _level_ is set. List logs related to the peer at the
  specified _level_

If _id_ is supplied and no matching nodes are found, a "peers" object with an
empty list is returned.

The objects in the _channels_ array will have at least these fields:

- _state_: Any of these strings:
  - `"OPENINGD"`: The channel funding protocol with the peer is ongoing and both
    sides are negotiating parameters.
  - `"CHANNELD_AWAITING_LOCKIN"`: The peer and you have agreed on channel
    parameters and are just waiting for the channel funding transaction to be
    confirmed deeply. Both you and the peer must acknowledge the channel funding
    transaction to be confirmed deeply before entering the next state.
  - `"CHANNELD_NORMAL"`: The channel can be used for normal payments.
  - `"CHANNELD_SHUTTING_DOWN"`: A mutual close was requested (by you or peer)
    and both of you are waiting for HTLCs in-flight to be either failed or
    succeeded. The channel can no longer be used for normal payments and
    forwarding. Mutual close will proceed only once all HTLCs in the channel
    have either been fulfilled or failed.
  - `"CLOSINGD_SIGEXCHANGE"`: You and the peer are negotiating the mutual close
    onchain fee.
  - `"CLOSINGD_COMPLETE"`: You and the peer have agreed on the mutual close
    onchain fee and are awaiting the mutual close getting confirmed deeply.
  - `"AWAITING_UNILATERAL"`: You initiated a unilateral close, and are now
    waiting for the peer-selected unilateral close timeout to complete.
  - `"FUNDING_SPEND_SEEN"`: You saw the funding transaction getting spent
    (usually the peer initiated a unilateral close) and will now determine what
    exactly happened (i.e. if it was a theft attempt).
  - `"ONCHAIN"`: You saw the funding transaction getting spent and now know what
    happened (i.e. if it was a proper unilateral close by the peer, or a theft
    attempt).
  - `"CLOSED"`: The channel closure has been confirmed deeply. The channel will
    eventually be removed from this array.
- _state\_changes_: An array of objects describing prior state change events.
- _opener_: A string `"local"` or `"remote`" describing which side opened this
  channel.
- _closer_: A string `"local"` or `"remote`" describing which side closed this
  channel or `null` if the channel is not (being) closed yet.
- _status_: An array of strings containing the most important log messages
  relevant to this channel. Also known as the "billboard".
- _owner_: A string describing which particular sub-daemon of `lightningd`
  currently is responsible for this channel. One of: `"lightning_openingd"`,
  `"lightning_channeld"`, `"lightning_closingd"`, `"lightning_onchaind"`.
- _to\_us\_msat_: A string describing how much of the funds is owned by us; a
  number followed by a string unit.
- _total\_msat_: A string describing the total capacity of the channel; a number
  followed by a string unit.
- _fee\_base\_msat_: The fixed routing fee we charge for forwards going out over
  this channel, regardless of payment size.
- _fee\_proportional\_millionths_: The proportional routing fees in ppm (parts-
  per-millionths) we charge for forwards going out over this channel.
- _features_: An array of feature names supported by this channel.

These fields may exist if the channel has gotten beyond the `"OPENINGD"` state,
or in various circumstances:

- _short\_channel\_id_: A string of the short channel ID for the channel; Format
  is `"BBBBxTTTxOOO"`, where `"BBBB"` is the numeric block height at which the
  funding transaction was confirmed, `"TTT"` is the numeric funding transaction
  index within that block, and `"OOO"` is the numeric output index of the
  transaction output that actually anchors this channel.
- _direction_: The channel-direction we own, as per BOLT \#7. We own
  channel-direction 0 if our node ID is "less than" the peer node ID in a
  lexicographical ordering of our node IDs, otherwise we own
  channel-direction 1. Our `channel_update` will use this _direction_.
- _channel\_id_: The full channel ID of the channel; the funding transaction ID
  XORed with the output number.
- _funding\_txid_: The funding transaction ID of the channel.
- _close\_to_: The raw `scriptPubKey` that was indicated in the starting
  **fundchannel\_start** command and accepted by the peer. If the `scriptPubKey`
  encodes a standardized address, an additional _close\_to\_addr_ field will be
  present with the standardized address.
- _private_: A boolean, true if the channel is unpublished, false if the channel
  is published.
- _funding\_msat_: An object, whose field names are the node IDs involved in the
  channel, and whose values are strings (numbers with a unit suffix) indicating
  how much that node originally contributed in opening the channel.
- _min\_to\_us\_msat_: A string describing the historic point at which we owned
  the least amount of funds in this channel; a number followed by a string unit.
  If the peer were to succesfully steal from us, this is the amount we would
  still retain.
- _max\_to\_us\_msat_: A string describing the historic point at which we owned
  the most amount of funds in this channel; a number followed by a string unit.
  If we were to successfully steal from the peer, this is the amount we could
  potentially get.
- _dust\_limit\_msat_: A string describing an amount; if an HTLC or the amount
  wholly-owned by one node is at or below this amount, it will be considered
  "dusty" and will not appear in a close transaction, and will be donated to
  miners as fee; a number followed by a string unit.
- _max\_total\_htlc\_in\_msat_: A string describing an amount; the sum of all
  HTLCs in the channel cannot exceed this amount; a number followed by a string
  unit.
- _their\_reserve\_msat_: A string describing the minimum amount that the peer
  must keep in the channel when it attempts to send out; if it has less than
  this in the channel, it cannot send to us on that channel; a number followed
  by a string unit. We impose this on them, default is 1% of the total channel
  capacity.
- _our\_reserve\_msat_: A string describing the minimum amount that you must
  keep in the channel when you attempt to send out; if you have less than this
  in the channel, you cannot send out via this channel; a number followed by a
  string unit. The peer imposes this on us, default is 1% of the total channel
  capacity.
- _spendable\_msat_ and _receivable\_msat_: A string describing an
  _**estimate**_ of how much we can send or receive over this channel in a
  single payment (or payment-part for multi-part payments); a number followed by
  a string unit. This is an _**estimate**_, which can be wrong because adding
  HTLCs requires an increase in fees paid to onchain miners, and onchain fees
  change dynamically according to onchain activity. For a sufficiently-large
  channel, this can be limited by the rules imposed under certain blockchains;
  for example, individual Bitcoin mainnet payment-parts cannot exceed
  42.94967295 mBTC.
- _minimum\_htlc\_in\_msat_: A string describing the minimum amount that an HTLC
  must have before we accept it.
- _their\_to\_self\_delay_: The number of blocks that the peer must wait to
  claim their funds, if they close unilaterally.
- _our\_to\_self\_delay_: The number of blocks that you must wait to claim your
  funds, if you close unilaterally.
- _max\_accepted\_htlcs_: The maximum number of HTLCs you will accept on this
  channel.
- _in\_payments\_offered_: The number of incoming HTLCs offered over this
  channel.
- _in\_offered\_msat_: A string describing the total amount of all incoming
  HTLCs offered over this channel; a number followed by a string unit.
- _in\_payments\_fulfilled_: The number of incoming HTLCs offered _and
  successfully claimed_ over this channel.
- _in\_fulfilled\_msat_: A string describing the total amount of all incoming
  HTLCs offered _and successfully claimed_ over this channel; a number followed
  by a string unit.
- _out\_payments\_offered_: The number of outgoing HTLCs offered over this
  channel.
- _out\_offered\_msat_: A string describing the total amount of all outgoing
  HTLCs offered over this channel; a number followed by a string unit.
- _out\_payments\_fulfilled_: The number of outgoing HTLCs offered _and
  successfully claimed_ over this channel.
- _out\_fulfilled\_msat_: A string describing the total amount of all outgoing
  HTLCs offered _and successfully claimed_ over this channel; a number followed
  by a string unit.
- _scratch\_txid_: The txid of the latest transaction (what we would sign and
  send to chain if the channel were to fail now).
- _last\_tx\_fee_: The fee on that latest transaction.
- _feerate_: An object containing the latest feerate as both _perkw_ and
  _perkb_.
- _htlcs_: An array of objects describing the HTLCs currently in-flight in the
  channel.

Objects in the _htlcs_ array will contain these fields:

- _direction_: Either the string `"out"` or `"in"`, whether it is an outgoing or
  incoming HTLC.
- _id_: A numeric ID uniquely identifying this HTLC.
- _amount\_msat_: The value of the HTLC.
- _expiry_: The blockheight at which the HTLC will be forced to return to its
  offerer: an `"in"` HTLC will be returned to the peer, an `"out"` HTLC will be
  returned to you. **NOTE** If the _expiry_ of any outgoing HTLC will arrive in
  the next block, `lightningd`(8) will automatically unilaterally close the
  channel in order to enforce the timeout onchain.
- _payment\_hash_: The payment hash, whose preimage must be revealed to
  successfully claim this HTLC.
- _state_: A string describing whether the HTLC has been communicated to or from
  the peer, whether it has been signed in a new commitment, whether the previous
  commitment (that does not contain it) has been revoked, as well as when the
  HTLC is fulfilled or failed offchain.
- _local\_trimmed_: A boolean, existing and `true` if the HTLC is not actually
  instantiated as an output (i.e. "trimmed") on the commitment transaction (and
  will not be instantiated on a unilateral close). Generally true if the HTLC is
  below the _dust\_limit\_msat_ for the channel.

On error the returned object will contain `code` and `message` properties, with
`code` being one of the following:

- -32602: If the given parameters are wrong.

## AUTHOR

Michael Hawkins <<michael.hawkins@protonmail.com>>.

## SEE ALSO

lightning-connect(7), lightning-fundchannel\_start(7), lightning-setchannel(7)

## RESOURCES

Main web site: <https://github.com/ElementsProject/lightning> Lightning RFC site
(BOLT \#9): <https://github.com/lightning/bolts/blob/master/09-features.md>

[comment]: # ( SHA256STAMP:6ba98a11876db615f4ea25f1afedf319a4bd4e50dad216306ea85b51b83b3f7b)
