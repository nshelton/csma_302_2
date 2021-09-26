using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class materialSwitcher2 : MonoBehaviour
{

    [SerializeField]
    public List<Material> _materials = new List<Material>();

    [SerializeField]
    public Renderer _renderer;

    void Update()
    {
      
        if (Input.GetKeyDown(KeyCode.Alpha1)) 
        {
            _renderer.material = _materials[0];
        }

        if (Input.GetKeyDown(KeyCode.Alpha2)) 
        {
            _renderer.material = _materials[1];
        }

        if (Input.GetKeyDown(KeyCode.Alpha3)) 
        {
            _renderer.material = _materials[2];
        }

        if (Input.GetKeyDown(KeyCode.Alpha4)) 
        {
            _renderer.material = _materials[3];
        }

        if (Input.GetKeyDown(KeyCode.Alpha5)) 
        {
            _renderer.material = _materials[4];
        }

        if (Input.GetKeyDown(KeyCode.Alpha6)) 
        {
            _renderer.material = _materials[5];
        }

    
    }
}
