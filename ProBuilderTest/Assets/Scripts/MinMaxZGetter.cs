using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MinMaxZGetter : MonoBehaviour {

    private void Awake()
    {
        MeshFilter myMesh = GetComponent<MeshFilter>();
        Vector3[] vertices = myMesh.mesh.vertices;
        float minZ = float.MaxValue;
        float maxZ = float.MinValue;
        foreach (Vector3 _v in vertices)
        {
            if (_v.z > maxZ)
            {
                maxZ = _v.z;
            }
            if (_v.z < minZ)
            {
                minZ = _v.z;
            }
        }
        Material myMat = GetComponent<MeshRenderer>().material;
        myMat.SetFloat("_MinZ", minZ+transform.position.z);
        myMat.SetFloat("_MaxZ", maxZ+transform.position.z);
    }
}
