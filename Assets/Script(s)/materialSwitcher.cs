using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class materialSwitcher : MonoBehaviour
{
    public Material[] materials;
    public GameObject model;
    public Material diffuse;
    public Material normal;
    public Material lambert;
    public Material normalMap;
    public Material phong;
    public Material matcap;
    public Material brdf;
    public Material reflection;
    public Material occulsion;
    public Material normalColor;


    void Start()
    {
        // each of these are public materials so just drag and drop them into a material and click play in the scene
        materials[0] = diffuse;
        materials[1] = normal;
        materials[2] = lambert;
        materials[3] = normalMap;
        materials[4] = phong;
        materials[5] = matcap;
        materials[6] = brdf;
        materials[7] = reflection;
        materials[8] = occulsion;
        materials[9] = normalColor;

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
        if (Input.GetKeyDown(KeyCode.Keypad5) || (Input.GetKeyDown(KeyCode.Alpha5)))
        {
            model.GetComponent<MeshRenderer>().material = materials[5];
        }
        if (Input.GetKeyDown(KeyCode.Keypad6) || (Input.GetKeyDown(KeyCode.Alpha6)))
        {
            model.GetComponent<MeshRenderer>().material = materials[6];
        }
        if (Input.GetKeyDown(KeyCode.Keypad7) || (Input.GetKeyDown(KeyCode.Alpha7)))
        {
            model.GetComponent<MeshRenderer>().material = materials[7];
        }
        if (Input.GetKeyDown(KeyCode.Keypad8) || (Input.GetKeyDown(KeyCode.Alpha8)))
        {
            model.GetComponent<MeshRenderer>().material = materials[8];
        }
        if (Input.GetKeyDown(KeyCode.Keypad9) || (Input.GetKeyDown(KeyCode.Alpha9)))
        {
            model.GetComponent<MeshRenderer>().material = materials[9];
        }

    }
}
