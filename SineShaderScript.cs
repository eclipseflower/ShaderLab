using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SineShaderScript : MonoBehaviour {

    public int rows = 100;
    public int cols = 100;
    public float dx = 0.5f;
    public float dz = 0.5f;

    public List<Vector3> vertices = new List<Vector3>();
    public List<int> indices = new List<int>();

	// Use this for initialization
	void Start () {
        GenVertices();

        Mesh mesh = GetComponent<MeshFilter>().mesh;

        mesh.Clear();

        // make changes to the Mesh by creating arrays which contain the new values
        mesh.vertices = vertices.ToArray();
        mesh.triangles = indices.ToArray();
    }

    void GenVertices()
    {
        for(int i = 0; i < rows; i++)
        {
            for(int j = 0; j < cols; j++)
            {
                Vector3 v = new Vector3(j * dx, 0.0f, -i * dz);
                vertices.Add(v);
            }
        }

        for(int i = 0; i < rows - 1; i++)
        {
            for(int j = 0; j < cols - 1; j++)
            {
                indices.Add(i * (rows - 1) + j);
                indices.Add(i * (rows - 1) + j + 1);
                indices.Add((i + 1) * (rows - 1) + j);
                indices.Add((i + 1) * (rows - 1) + j);
                indices.Add(i * (rows - 1) + j + 1);
                indices.Add((i + 1) * (rows - 1) + j + 1);
            }
        }
    }
	
	// Update is called once per frame
	void Update () {
    }
}
