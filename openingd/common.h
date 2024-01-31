#ifndef LIGHTNING_OPENINGD_COMMON_H
#define LIGHTNING_OPENINGD_COMMON_H

#include "config.h"

struct amount_sat;
struct bip340sig;
struct bitcoin_tx;
struct bitcoin_signature;
struct channel_config;

bool check_eltoo_config_bounds(const tal_t *ctx, struct amount_sat funding,
			       u32 max_shared_delay,
			       struct amount_msat min_effective_htlc_capacity,
			       const struct channel_config *remoteconf,
			       const struct channel_config *localconf,
			       char **err_reason);

bool check_config_bounds(const tal_t *ctx, struct amount_sat funding,
			 u32 feerate_per_kw, u32 max_to_self_delay,
			 struct amount_msat min_effective_htlc_capacity,
			 const struct channel_config *remoteconf,
			 const struct channel_config *localconf,
			 bool option_anchor_outputs,
			 bool option_anchors_zero_fee_htlc_tx,
			 bool option_commit_zero_fees,
			 char **err_reason);

/* Any anchor type, including option_commit_zero_fees */
bool anchors_negotiated(struct feature_set *our_features,
			const u8 *their_features);

u8 *no_upfront_shutdown_script(const tal_t *ctx, bool developer,
			       struct feature_set *our_features,
			       const u8 *their_features);

void validate_initial_commitment_signature(int hsm_fd, struct bitcoin_tx *tx,
					   struct bitcoin_signature *sig);

char *validate_remote_upfront_shutdown(const tal_t *ctx,
				       struct feature_set *our_features,
				       const u8 *their_features,
				       u8 *shutdown_scriptpubkey STEALS,
				       u8 **state_script);

void validate_initial_update_psig(int hsm_fd, struct channel_id *channel_id,
				  struct bitcoin_tx *update_tx,
				  struct partial_sig *p_sig);
#endif /* LIGHTNING_OPENINGD_COMMON_H */
