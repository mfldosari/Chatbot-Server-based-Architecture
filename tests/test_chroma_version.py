import chromadb

def test_chroma_version():
    expected_version = "0.4.24"
    actual_version = chromadb.__version__
    assert actual_version == expected_version, f"Expected ChromaDB version {expected_version}, but got {actual_version}"
