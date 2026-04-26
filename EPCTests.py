import requests
import json
import time
from robot.api import logger

class EPCTests:
    ROBOT_LIBRARY_SCOPE = "TEST"

    def __init__(self, base_url="http://localhost:8000"):
        self.base_url = base_url

    def reset_response(self):
        response = requests.post(f"{self.base_url}/reset")
        response.raise_for_status()
        return response.status_code

    def attach_ue(self, ue_id):
        payload = {"ue_id": ue_id}
        response = requests.post(f"{self.base_url}/ues", json=payload)
        response.raise_for_status()
        return response.json()

    def attach_ue_without_raise(self, ue_id):
        payload = {"ue_id": ue_id}
        response = requests.post(f"{self.base_url}/ues", json=payload)
        return response.status_code

    def detach_ue(self, ue_id):
        response = requests.delete(f"{self.base_url}/ues/{ue_id}")
        response.raise_for_status()
        return response.json()

    def detach_ue_without_raise(self, ue_id):
        response = requests.delete(f"{self.base_url}/ues/{ue_id}")
        return response.status_code

    def get_ue(self, ue_id):
        response = requests.get(f"{self.base_url}/ues/{ue_id}")
        response.raise_for_status()
        return response.json()

    def get_ue_without_raise(self, ue_id):
        response = requests.get(f"{self.base_url}/ues/{ue_id}")
        return response.status_code

    def get_ues(self):
        response = requests.get(f"{self.base_url}/ues")
        response.raise_for_status()
        return response.json()["ues"]

    def get_ues_length(self):
        response = requests.get(f"{self.base_url}/ues")
        response.raise_for_status()
        data = response.json()
        ues_list = data["ues"]
        return len(ues_list)

    def add_bearer(self, ue_id, bearer_id):
        payload = {"bearer_id": bearer_id}
        response = requests.post(f"{self.base_url}/ues/{ue_id}/bearers", json=payload)
        response.raise_for_status()
        return response.json()

    def add_bearer_without_raise(self, ue_id, bearer_id):
        payload = {"bearer_id": bearer_id}
        response = requests.post(f"{self.base_url}/ues/{ue_id}/bearers", json=payload)
        return response.status_code

    def delete_bearer(self, ue_id, bearer_id):
        response = requests.delete(f"{self.base_url}/ues/{ue_id}/bearers/{bearer_id}")
        return response.status_code

    def start_traffic(self, ue_id, bearer_id, protocol, bps=None, kbps=None, mbps=None):
        payload = {"protocol": protocol}
        if bps is not None:
            payload["bps"] = float(bps)
        if kbps is not None:
            payload["kbps"] = float(kbps)
        if mbps is not None:
            payload["Mbps"] = float(mbps)

        url = f"{self.base_url}/ues/{ue_id}/bearers/{bearer_id}/traffic"
        logger.info(f"URL: {url}")
        logger.info(f"Payload: {payload}")
        response = requests.post(url, json=payload)
        logger.info(f"Status: {response.status_code}")
        logger.info(f"Response body: {response.text}")
        return response

    def stop_traffic(self, ue_id, bearer_id):
        response = requests.delete(f"{self.base_url}/ues/{ue_id}/bearers/{bearer_id}/traffic")
        response.raise_for_status()
        return response.json()

    def get_traffic_stats(self, ue_id, bearer_id):
        response = requests.get(f"{self.base_url}/ues/{ue_id}/bearers/{bearer_id}/traffic")
        response.raise_for_status()
        return response.json()

    def start_traffic_without_raise(self, ue_id, bearer_id, protocol, mbps=None):
        payload = {"protocol": protocol}
        if mbps is not None:
            payload["Mbps"] = float(mbps)
        response = requests.post(f"{self.base_url}/ues/{ue_id}/bearers/{bearer_id}/traffic", json=payload)
        return response.status_code

    def get_ues_stats(self, ue_id):
        response = requests.get(f"{self.base_url}/ues/stats?ue_id={ue_id}")
        response.raise_for_status()
        return response.json()

    def get_global_stats(self):
        response = requests.get(f"{self.base_url}/ues/stats")
        response.raise_for_status()
        return response.json()

    def get_ue_stats_with_details(self, ue_id):
        response = requests.get(f"{self.base_url}/ues/stats?ue_id={ue_id}&include_details=true")
        response.raise_for_status()
        return response.json()

