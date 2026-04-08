import requests
import json

class EPCTests:
    ROBOT_LIBRARY_SCOPE = "TEST"
    def __init__(self, base_url="http://localhost:8000"):
        self.base_url = base_url

    def reset_response(self):
        """Reset the EPC simulator state"""
        response = requests.post(f"{self.base_url}/reset")
        response.raise_for_status()
        return response.status_code

    def attach_ue(self, ue_id):
        """Attach a UE (User Equipment) with the specified ID"""
        payload = {"ue_id": ue_id}
        response = requests.post(
            f"{self.base_url}/ues",
            json=payload
        )
        response.raise_for_status()
        return response.json()

    def get_ue(self, ue_id):
        """Get UE details by ID"""
        response = requests.get(f"{self.base_url}/ues/{ue_id}")
        response.raise_for_status()
        return response.json()

    def get_ues_length(self):
        """Get the total number of attached UEs"""
        response = requests.get(f"{self.base_url}/ues")
        response.raise_for_status()
        data = response.json()
        ues_list = data["ues"]
        return len(ues_list)