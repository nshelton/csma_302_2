using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class materialSwitcherProject2 : MonoBehaviour
{
    public Material[] materials;
    public GameObject model;
    public Material Blend;
    public Material Clip;
    public Material Displace;
    public Material Displace_Reflection;
    public Material Hologram;



    void Start()
    {
        // each of these are public materials so just drag and drop them into a material(unless you open the SampleScene then it should be done for you) and click play in the scene
        //script should be attached to the materialSwitcherController empty gameObject in the scene already
        materials[0] = Blend;
        materials[1] = Clip;
        materials[2] = Displace;
        materials[3] = Displace_Reflection;
        materials[4] = Hologram;

    }

    void Update()
    {   
        // This code will switch the current material of the object to a new one by either pushing the number keys on the keyboard or the number keys in the keypad (values from 0-9)

        if (Input.GetKeyDown(KeyCode.Keypad0) || (Input.GetKeyDown(KeyCode.Alpha0)))
        {
            model.GetComponent<MeshRenderer>().material = materials[0];
        }
        if (Input.GetKeyDown(KeyCode.Keypad1) || (Input.GetKeyDown(KeyCode.Alpha1)))
        {
            model.GetComponent<MeshRenderer>().material = materials[1];
        }
        if (Input.GetKeyDown(KeyCode.Keypad2) || (Input.GetKeyDown(KeyCode.Alpha2)))
        {
            model.GetComponent<MeshRenderer>().material = materials[2];
        }
        if (Input.GetKeyDown(KeyCode.Keypad3) || (Input.GetKeyDown(KeyCode.Alpha3)))
        {
            model.GetComponent<MeshRenderer>().material = materials[3];
        }
        if (Input.GetKeyDown(KeyCode.Keypad4) || (Input.GetKeyDown(KeyCode.Alpha4)))
        {
            model.GetComponent<MeshRenderer>().material = materials[4];
        }
        

    }
}
