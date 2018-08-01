using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[System.Serializable]
public struct VisiblePart
{
    public Material[] originalMaterials;
    public Material[] seeThroughMaterials;
    public MeshRenderer visibleObject;
}

public class AlwaysVisibleObject : MonoBehaviour {

    public List<VisiblePart> myVisibleParts;

	// Use this for initialization
	void Start () {
		
	}
	
	// Update is called once per frame
	void Update () {
        RaycastHit hit = new RaycastHit();
        Vector3 mainCameraPosition = Camera.main.transform.position;
        Ray cameraToObj = new Ray(mainCameraPosition, transform.position - mainCameraPosition);
        if (Physics.Raycast(cameraToObj, out hit))
        {
            if (hit.collider.gameObject == gameObject)
            {
                SetOriginalMaterials();
            } 
            else
            {
                SetSeeThroughMaterials();
            }
        } 
        else
        {
            SetSeeThroughMaterials();
        }
	}

    void SetOriginalMaterials()
    {
        foreach (VisiblePart _vp in myVisibleParts)
        {
            _vp.visibleObject.materials = _vp.originalMaterials;
        }
    }

    void SetSeeThroughMaterials()
    {
        foreach (VisiblePart _vp in myVisibleParts)
        {
            _vp.visibleObject.materials = _vp.seeThroughMaterials;
        }
    }
}
