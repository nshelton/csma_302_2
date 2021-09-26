using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WGSMat : MonoBehaviour
{
    // Start is called before the first frame update
    public Material[] materials;
    public Texture topBaseTex;
    public Texture topNormalTex;
    public GameObject top;
    public Texture bottomBaseTex;
    public Texture bottomNormalTex;
    public GameObject bottom;
    Material curMat;

    void Start()
    {
        if (materials.Length > 0)
        {
            SwitchToMat(materials[0]);
        }
    }

    void SwitchToMat(Material mat) {
        curMat = mat;
        foreach (Renderer renderer in top.GetComponentsInChildren<Renderer>()) {
            renderer.material = mat;
            renderer.material.SetTexture("_MainTex",topBaseTex);
            renderer.material.SetTexture("_NormalTex",topNormalTex);
        }

        foreach (Renderer renderer in bottom.GetComponentsInChildren<Renderer>()) {
            renderer.material = mat;
            renderer.material.SetTexture("_MainTex",bottomBaseTex);
            renderer.material.SetTexture("_NormalTex",bottomNormalTex);
        }
        
        // Set top image
        
    }

    // Update is called once per frame
    void Update()
    {
        for (int i = 1; i < materials.Length+1; i++)
        {
            var key = i.ToString();
            if (i == 10) {
                key = "0";
            }
            if (Input.GetKeyDown(key))
            {
                SwitchToMat(materials[i-1]);
            }
        }

        transform.Rotate(new Vector3(0, 20 * Time.deltaTime, 0));
        //Camera.main.transform.RotateAround(transform.position, Vector3.up, 40 * Time.deltaTime);
    }

    private void OnGUI()
    {
        // Cool little ui showing what mat is selected
        GUIStyle style = new GUIStyle();
        style.fontSize = 40;
        style.normal.textColor = Color.black;
        GUI.Label(new Rect(15, 15, 200, 60), curMat.shader.name, style);
    }
}
