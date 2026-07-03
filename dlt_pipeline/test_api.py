"""Test if Stack Exchange API is accessible"""
import urllib.request
import urllib.error
import json

BASE_URL = "https://api.stackexchange.com/2.3"

print("Testing Stack Exchange API connection...")
print()

# Test 1: Simple users endpoint
print("TEST 1: Fetching users (first page)")
try:
    url = f"{BASE_URL}/users?site=stackoverflow&page=1&pagesize=10"
    response = urllib.request.urlopen(url, timeout=10)
    data = json.loads(response.read().decode('utf-8'))
    print(f"✓ Status: {response.status}")
    print(f"✓ Items count: {len(data.get('items', []))}")
    print(f"✓ Has more: {data.get('has_more', False)}")
    if data.get('items'):
        print(f"✓ Sample user: {data['items'][0].get('display_name', 'N/A')}")
    print()
except Exception as e:
    print(f"✗ Error: {e}")
    print()

# Test 2: Check response structure
print("TEST 2: Full response structure:")
try:
    url = f"{BASE_URL}/users?site=stackoverflow&page=1&pagesize=1"
    response = urllib.request.urlopen(url, timeout=10)
    data = json.loads(response.read().decode('utf-8'))
    print(json.dumps(data, indent=2)[:500] + "...")
except Exception as e:
    print(f"Error: {e}")
