extends Node

# --- COMBAT SIGNALS ---
# Broadcast when any entity's health changes. Useful for health bars.
signal health_changed(entity: Node, current_health: int, max_health: int)

# Broadcast when an entity dies. Spawners or quest trackers can listen to this.
signal entity_died(entity: Node)

# --- PLAYER SIGNALS ---
# Broadcast specifically when the player's stats or cooldowns change.
signal player_cooldown_updated(ability_name: String, time_remaining: float)
