extends Node

var quests = {
	"find_ring": {"status": "not_started"},
	"help_villager": {"status": "not_started"}
}

func start_quest(id):
	quests[id]["status"] = "in_progress"

func complete_quest(id):
	quests[id]["status"] = "completed"

func is_started(id):
	return quests[id]["status"] in ["in_progress", "completed"]

func is_completed(id):
	return quests[id]["status"] == "completed"
