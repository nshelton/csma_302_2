using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SwitchMaterial : MonoBehaviour
{
    // Start is called before the first frame update
    public Material[] materials;

    void Start()
    {
        if (materials.Length > 0)
        {
            GetComponent<Renderer>().material = materials[0];
        }
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
                GetComponent<Renderer>().material = materials[i-1];
            }
        }

        transform.Rotate(new Vector3(0, 10 * Time.deltaTime, 0));
    }

    private void OnGUI()
    {
        // Cool little ui showing what mat is selected
        GUIStyle style = new GUIStyle();
        style.fontSize = 40;
        style.normal.textColor = Color.blue;
        GUI.Label(new Rect(15, 15, 200, 60), GetComponent<Renderer>().material.shader.name, style);
    }
}
