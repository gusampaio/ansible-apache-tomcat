import requests

def test_page_response():
    test_url = "http://localhost:8080/sample"
    response = get_page(test_url)
    assert response.status_code == 200

def get_page(search_url):
  page = requests.get(search_url)
  return page

