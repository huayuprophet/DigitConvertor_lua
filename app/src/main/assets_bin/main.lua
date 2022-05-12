require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.content.Context"
import "android.content.Intent"
import "android.text.method.DigitsKeyListener"
import "android.net.Uri"
digital=require 'digital'
activity.setContentView(loadlayout("layout"))
checkGroup.check(2130706432)
getmode={[2130706432]=1,[2130706433]=2,[2130706434]=3}
modelimit={16384,96,52}
numput.setKeyListener(DigitsKeyListener.getInstance("0123456789"))
--print(checkGroup.getCheckedRadioButtonId())
function showdialog(title,content)
  cryptinfo=AlertDialog.Builder(this)
  .setTitle(title)
  .setMessage(content)
  .setPositiveButton("复制",{onClick=function(v)
      activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(content)
      print("复制成功")
  end})
  .setNeutralButton("转发内容",
  {onClick=
    function()
      local intent=Intent(Intent.ACTION_SEND)
      .setType("text/plain")
      .putExtra(Intent.EXTRA_TEXT, content)
      .setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      activity.startActivity(Intent.createChooser(intent,"发送文字到："))
    end
  })
  .setNegativeButton("取消",nil)
  cryptinfo.show()
end
function mkcov.onClick(obj)
  local numstr,radiocheck,mode=numput.Text,checkGroup.getCheckedRadioButtonId()
  mode=getmode[radiocheck]
  if type(tonumber(numstr))=='number' and radiocheck~=-1 and #numstr<=modelimit[mode] then
    showdialog('小写数字转大写',digital.getCapitalize(numstr,mode))
   else
    showdialog('错误','请按序检查：\n1.您输入的内容须为阿拉伯数字整数，且不能以0开头。\n2.须选择进位方式，或应用初始化失败。\n5.数字过大，超出可表达范围。\n4.其他未知的错误。')
  end
end
function about.onClick(obj)
  showdialog('关于页','计数单位转换，是一个能够实现完整的大小写数字转换的工具应用。\n（暂仅实现小写数字转大写）\nversion：0.0.1-Alpha\n关于大写数字的读数规范和争议，请点击主页“更多”按钮了解详情。\n挖坑：用户自定义数字和单位字符、大写数字转小写、其他。\n长按关于可联系作者。')
end
function about.onLongClick(obj)
  showdialog('联系作者','qq：1410434961\nemail：huayuprophet@gmail.com')
end
function more.onClick(obj)
  activity.startActivity(Intent("android.intent.action.VIEW",Uri.parse('https://docs.qq.com/doc/DWmt1UmZuZWlqSW1P')))
end