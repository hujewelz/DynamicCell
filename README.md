# iOS7和iOS下的自适应cell
我们开发中，在使用UITableView的时候经常会遇到这样的需求：table view的cell中的内容是动态的。于是我们就在table view的代理中手动去计算cell中的内容高度。这样做有两个问题：  
 1. 计算代码冗长、复杂。
 2. 每次 reload tableview 的时候，系统会先计算出每一个 cell 的高度，等所有高度计算完毕，确定了 tableview 的`contentSize`后，才开始渲染视图并显示在屏幕上。如果数据比较多，就会感受到非常明显的卡顿。

所以，我们应该寻找其他的解决方案。如果你的项目只支持iOS8及以上，那么恭喜你，你只用简单的几步就可以实现自适应cell了。如果是iOS7也没关系，后面我也会讲到，如何在iOS下实现自适应cell。

在讲具体的实现之前，必须得说一下iOS7中新增的一个API：

    - (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath;
这个方法用于返回一个 cell 的预估高度，如果实现了这个代理方法，tableview 首次加载的时候就不会调用heightForRowAtIndexPath 方法，而是用 estimatedHeightForRowAtIndexPath 返回的预估高度计算 tableview 的`contentSize`，然后 tableview 就可以显示出来了，等到 cell 可见的时候，再去调用heightForRowAtIndexPath 获取 cell 的正确高度。

通过实现这个代理方法，解决了首次加载 table view 出现的性能问题，但是并没有让我们从复杂的计算中解脱出来。下面我会通过例子来讲解一下在iOS7和iOS8中自适应cell的实现。

## iOS8的自适应cell
要想让table view的cell自适应，有几个要点：  
    1. 设置的` AutoLayout` 约束必须让 cell 的 `contentView `知道如何自动伸展。关键点是 `contentView` 的 4 个边都要设置连接到内容的约束，并且内容是会动态改变尺寸的。其实只要记住，我们在设置约束时只要能让`contentView`能被内容撑起来就可以了。  
    2. UITableView 的`rowHeight` 的值要设置为 `UITableViewAutomaticDimension`。  
    3. 和 iOS 7 一样，可以实现 estimatedHeightForRowAtIndexPath 代理方法提升 table view 的第一次加载速度。也可以直接这样：` self.tableView.estimatedRowHeight =  60`。

好了咱们来直接上代码：  
在 Xcode 中新建一个项目，设置好tableView后，自定义一个`UITableViewCell`:  

![屏幕快照 2016-02-24 上午10.25.12.png](http://upload-images.jianshu.io/upload_images/1351863-2776d0ed9c975732.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

创建好之后是这样的：  

![屏幕快照 2016-02-24 上午10.35.26.png](http://upload-images.jianshu.io/upload_images/1351863-af6d55fece3b3897.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

下面来看一下约束，这个是决定你的cell能否自适应的关键。    
UIImageView约束如下：
 1. 左边距离`contentView`左边15
 2. 顶部距离`contentView`顶部8
 3.  `width` 和 `height `为 40
 4. 底部距离`contentView`底部**大于或等于0**（为了防止文本内容太少，导致 cell 高度小于图片高度）

UILabel有四个约束：
 1. 左边距离图片8
 2. 右边距离`contentView`右边15
 3. 顶部距离`contentView`顶部8
 4. 底部距离`contentView`底部4

不要忘了将UILabel的`numberOfLines `设为0
以上约束就可以将`contentView`撑起来了。  
控制器中代码如下：
```
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[Cell1 nib] forCellReuseIdentifier:[Cell1 identifier]];
}

```
```
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Cell1 *cell1 = [tableView dequeueReusableCellWithIdentifier:[Cell1 identifier] forIndexPath:indexPath];
    
    cell1.textLab.text = self.data[indexPath.row];

    return cell1;
}
```
决定cell自适应内容的也就这两行代码：`self.tableView.rowHeight = UITableViewAutomaticDimension; self.tableView.estimatedRowHeight = 60;`
看一下效果：

![屏幕快照 2016-02-24 上午10.49.42.png](http://upload-images.jianshu.io/upload_images/1351863-fe824810ee5ab890.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## iOS7的自适应cell
iOS7相比iOS8实现起来代码多一点但是并不复杂，还是用上个例子中的cell,
我们在heightForRowAtIndexPath中计算高度：
```

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [Cell1 identifier];
    Cell1 *cell1 = self.offScreenCells[identifier];
    if (!cell1) {
        cell1 = [[[NSBundle mainBundle] loadNibNamed:@"Cell1" owner:nil options:nil] lastObject];
        self.offScreenCells[identifier] = cell1;
    }
    cell1.textLab.text = self.data[indexPath.row];
    [cell1 setNeedsUpdateConstraints];
    [cell1 updateConstraintsIfNeeded];
    
    CGFloat height = [cell1.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    return height + 1;
}
```
这里主要使用`systemLayoutSizeFittingSize:`来获取内容的高度，所以在获取高度之前我们必须有一个实例化的cell。我在这里使用字典存储cell，主要是因为一个tableView中可能有多种不同的cell。获取到cell之后将内容添加上去，然后更新约束。

![屏幕快照 2016-02-24 上午11.27.10.png](http://upload-images.jianshu.io/upload_images/1351863-0928f4b2616bdf6f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

要想实现上图效果还有一个需要注意的地方，那就是要给显示label的`preferredMaxLayoutWidth`赋一个值:
```
- (void)awakeFromNib {
    // Initialization code
    self.textLab.preferredMaxLayoutWidth = 250;
}
```
也可以在给label设置约束时直接将`width`定死，而不是通过距离`contentView`右边间距来确定宽度。

以上就是在iOS7及以上版本中实现自适应cell的方法，如果有什么错误，希望大家能指正。你们的支持将是我写作的最大动力。

###备注：
![image](https://github.com/hujewelz/DynamicCell/blob/master/explain.png)

要想在ios7下测试，注释掉图片中的三行代码即可，这只是为了在demo中演示ios7和ios8才添加的
