local class,wordF,digitR,digitG,carrymeta,carry,tonumtable,setCarry,coipairs,fillunit,formatmode,numtableformat,tabletostr
class={}
wordF={[-1]='',[0]='零','一','二','三','四','五','六','七','八','九'}
digitR={[0]='','','十','百','千'}
digitG={[0]='','万','亿','兆','京','垓','秭','穰','沟','涧','正','载','极'}
carrymeta={}
function carrymeta:adder(index,boolean)--进位加法器
  local v=self[index]
  local carryout=v and boolean
  self[index]=not carryout and (v or boolean)
  if carryout then
    self:adder(index+1,carryout)
  end
end
function setCarry()--设置元表
  return setmetatable({[1]=false},{__index=carrymeta})
end
digitG.get={function(r,g)--获取计数单位
    carry=carry or setCarry()--检查或建立进位器
    carry:adder(1,true)
    for k,v in ipairs(carry) do
      if v then
        return k
      end
    end
  end,--自乘-上数
  function(r,g) return (g+1)%2==1 and 1 or (g+1)//2+1 end,--亿进-中数
  function(r,g) return g+1 end,}--万进，日式
function tonumtable(numstr)--num字符串转数字表
  local wordN={}
  for d in string.gmatch(numstr,'%d') do
    table.insert(wordN,tonumber(d))
  end
  return wordN
end
function coipairs(array)--反向迭代器
  local k,i=#array+1,0
  return function()
    k,i=k-1,i+1
    local v=array[k]
    if v then
      return k,v,i
    end
  end
end
function fillunit(numtable,digitmode)--为数字数组填入计数单位
  carry=nil--清空进位器，防止出错
  local rindex,gindex=1,0
  local output={}
  for i=1,#numtable do output[i]={} end
  for k,v,i in coipairs(numtable) do
    output[k][1],output[k][2]=v,rindex
    if rindex==#digitR and output[k-1] then
      output[k-1][3]=digitmode(rindex,gindex)
      rindex,gindex=1,gindex+1
     else
      rindex=rindex+1
    end
  end
  return output
end
formatmode={--不能略读单位名称的情况
  function(zcount,drlen,lv)return zcount<drlen*lv end,--上数
  function(zcount,drlen,lv)
    if lv==1 then
      return zcount<drlen
     else
      return zcount<drlen*2
    end
  end,--中数
  function(z,d,l)return z<d end}--日式
function numtableformat(numtable,mode)--为数字表去掉多余的零和应当略读的单位
  local zerocounting,drlen,iszero=0,#digitR
  for k,v in ipairs(numtable) do
    numtable[k][4]=-1
    if v[1]==0 then
      numtable[k][1],numtable[k][2],zerocounting,iszero=-1,0,zerocounting+1,true
     elseif numtable[k-1] then
      numtable[k-1][4],zerocounting,iszero=iszero and 0 or -1,0,nil
    end
    if v[3] then
      numtable[k][3]=mode(zerocounting,drlen,v[3]) and v[3] or 0
     else
      numtable[k][3]=0
    end
  end
end
function tabletostr(numtable)--读数字表并连接为文字字符串
  local output=''
  for k,v in ipairs(numtable) do
    output=output..wordF[v[1]]..digitR[v[2]]..digitG[v[3]]..wordF[v[4]]
  end
  return output
end
function class.getCapitalize(numstr,mode)
  local tb=fillunit(tonumtable(numstr),digitG.get[mode])
  numtableformat(tb,formatmode[mode])
  return tabletostr(tb)
end
return class
--numstr='12304567898000000765430012500097000000000604106800'
--mode=1
--print(class.getCapitalize(numstr,mode))