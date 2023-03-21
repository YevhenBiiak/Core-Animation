# Core-Animation

<p align=center>
  <img width=30% src="https://user-images.githubusercontent.com/80542175/182438260-30a78c94-b5f5-4be4-85ab-86c5e0dde2c1.gif"> 
  <img width=30% src="https://user-images.githubusercontent.com/80542175/182438262-8c999a4d-d0a5-4057-ace3-adcb5906119b.gif">
  <img width=32.6% src="https://user-images.githubusercontent.com/80542175/182678520-d138ac28-3b9f-4a42-b53f-5b8766863e09.gif">
</p>

<details><summary><h3>More GIFs</h3></summary>
  <p>
    <img width=30% src="https://user-images.githubusercontent.com/80542175/182438235-09f2ae9f-edb2-4318-a476-609a1b7f6e67.gif"> 
    <img width=30% src="https://user-images.githubusercontent.com/80542175/182438258-9b7eaae4-3725-431c-a3dc-509ae67255ff.gif">
  </p>  
</details>
  
<details><summary><h3>Horizontal layout</h3></summary>
  <p align=center>
    <img width=74% src="https://user-images.githubusercontent.com/80542175/182438270-a542fc36-e198-412c-b892-ffcfbfa8d85e.png">
    <img width=74% src="https://user-images.githubusercontent.com/80542175/182438272-d2ec2878-afe2-4a9e-a5f4-01cc1efef387.png">
    <img width=74% src="https://user-images.githubusercontent.com/80542175/182438273-72400582-223f-4670-81fa-7ecb86a04597.png">
  </p>  
</details>


## Learned how to: 

- draw circle and arc using CAShapeLayer and UIBezierPath
- animate properties of CA classes using CABasicAnimation and CASpringAnimation
- animate UILabel text content using CADisplayLink
- replicate layers using CAReplicatorLayer with move and rotate transforms
- create a CAEmitterLayer layer with CAEmitterCell and manage its properties

## Conclusion

Using CABasicAnimation, I have come to the conclusion that the overlaid animation layer disappears after it is launched and does not affect the main layer. Additionally, the base layer can only contain one animation layer.

| Used CALayer classes | Additionally |
--- | ---
`CALayer` | `UIBezierPath`
`CAShapeLayer` | `CABasicAnimation`
`CAEmitterLayer` | `CASpringAnimation`
`CAEmitterCell` | `CADisplayLink`
`CAReplicatorLayer` | `CGAffineTransforms`

