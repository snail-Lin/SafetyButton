## SafetyButton
防止按钮被暴力点击，在很短的时间内执行同一响应事件，例如push控制器等等。

## 使用
使用MethodSwizzling为每个按钮加上clickedTime属性,直接导入分类即可。  
在第一次点击按钮后会马上响应事件，不会延迟，在第二次点击后，会判断上次点击的时间间隔是否超过设置值，使用方法如下
```swift
let submitBtn: UIButton = {
    let btn = UIButton(frame: CGRect.zero)
    //若不设置默认为0.7秒
    btn.clickedTime = 2
    return btn
}()
```
若希望取消时间间隔，使用
```swift
    btn.clickedTime = -1
```



