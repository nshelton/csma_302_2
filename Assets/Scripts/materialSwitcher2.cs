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
        if (Input.GetKeyDown(KeyCode.Q)) 
        {
            _renderer.material = _materials[0];
        }

        if (Input.GetKeyDown(KeyCode.W)) 
        {
            _renderer.material = _materials[1];
        }

        if (Input.GetKeyDown(KeyCode.E)) 
        {
            _renderer.material = _materials[2];
        }

        if (Input.GetKeyDown(KeyCode.R)) 
        {
            _renderer.material = _materials[3];
        }

        if (Input.GetKeyDown(KeyCode.T)) 
        {
            _renderer.material = _materials[4];
        }

        if (Input.GetKeyDown(KeyCode.Y)) 
        {
            _renderer.material = _materials[5];
        }

    }
}
