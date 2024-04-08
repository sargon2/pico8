pico-8 cartridge // http://www.pico-8.com
version 42
__lua__
function w(e)local n={}for e,t in pairs(e)do n[e]=t end return n end function F(n,e)if(#n~=#e)return#n-#e
for t=1,#n do local n=y(n,t)-y(e,t)if(n~=0)return n
end return 0end function O(e,t,n,i)n=n or 1return sub(t,n,i and#t or n+#e-1)==e end function B(n)local t,e=split(n,"0"),1if(#t>#n)return"0"
while(t[e]=="")e+=1
return sub(n,e)end function y(e,n)return sub(e,n,n)end function W(n)assert(not n,"invalid operation")end function G(n,e)n=n or{"+","0","qnan"}if(type(n)~="table")n=no(tostr(n))
add(n,e or 32)return C(n)end function s(e,...)local t,n={...},32767.99999for e in all(t)do n=min(n,e[4])end add(e,n)return e end function n3(n)return G(n,32)end function x(n)return G(n,64)end function np(n)return G(n,128)end function C(n)return nr(nf(nd(n)))end function U(n)return type(n[3])=="number"end function b(n)return O("nan",n[3],2)end function g(n)return n[3]=="snan"end function m(n,e)return e and n[2]=="0"and n[3]~="inf"and 0or n[1]=="-"and-1or 1end function n_(n)if(b(n))return n[2]
end function nl(n)local t=m(n)<0and"-"or""if U(n)then local n,e=n[2],n[3]local i=e+#n-1if e==0then t..=n else while(#n<-e)n="0"..n
t..=sub("0"..n,#n<=-e and 1or 2,e-1).."."..sub(n,e)end else t..=g(n)and"snan"or b(n)and"nan"or"infinity"end return t end function nd(n,e)e=e or n[4]\32*9-2if U(n)then if(e==0)return s({"+","0",0},n)
local i=B(n[2])if(#i<=e)n[2]=i return n
local d,t,f,o,r=n[1],"",n[3]+#i-e,y(i,e+1)>="5"and 1or 0,e repeat o+="0"..sub(i,max(r-3),max(r))t=sub("000"..o%10000,-4)..t o\=10000r-=4until r<1and o<=0t=B(t)if(#t>e)t=sub(t,1,e)f+=1
return s({d,t,f},n)end local t=w(n)t[2]=e>1and b(n)and sub(t[2],1-e)or"0"return t end function nf(n)if(not U(n))return n
if(n[3]+#n[2]-2<=(3*2^(n[4]\32*2+4)-1)\2)return n
return s({n[1],"0","inf"},n)end function nr(e)if(not U(e))return e
local n=w(e)local t=-((3*2^(n[4]\32*2+4)-1)\2)if(n[3]+#n[2]-1>t)return e
while(n[3]<t-n[4]\32*9+3)n[2]=sub(n[2],1,-2)n[3]+=1
if(n[2]=="")n[2]="0"
return n end function H(t,i)local n,e=w(t),w(i)if(g(t))n[3]="qnan"return n
if(g(i))e[3]="qnan"return e
if(b(n))return n
if(b(e))return e
if(m(n,true)~=m(e,true))S,T=m(n,true),m(e,true)n,e=s({y("-++",S+2),tostr(S),0},n),s({y("-++",T+2),tostr(T),0},e)
return m(V(n,e),true)end function X(n,e)local n,e=I(n,e,true)assert(#n[2]+n[3]<=n[4]\32*9-2,"division impossible")while(n[3]>0)n[2]..="0"n[3]-=1
return C(n),e end function n4(n,e)local n=X(n,e)return n end function J(n,e)W(g(n)or g(e))if(b(n))return w(n)
if(b(e))return w(e)
local o,r,d,l,i,t=n[1],e[1],n[2],e[2],n[3],e[3]if i=="inf"then W(t=="inf"and o~=r)return s({o,"0","inf"},n)elseif t=="inf"then return s({r,"0","inf"},e)end for n=1,abs(i-t)do if(i>t)d..="0"else l..="0"
end local u,c,f,t,i=F(d,l)<0,min(i,t),"",0,1repeat local n,e="0"..sub(d,-i-2,-i),"0"..sub(l,-i-2,-i)if o~=r then if(u)t+=e-n else t+=n-e
else t+=n+e end f=sub("00"..t%1000,-3)..f t\=1000i+=3until i>max(#d,#l)and t<=0local t,i="+",true for n=1,#f do if(y(f,n)~="0")i=false break
end if i then if(o=="-"and r=="-")t="-"
else t=u and r or o end return C(s({t,f,c},n,e))end function V(e,n)local n=w(n)n[1]=n[1]=="+"and"-"or"+"return J(e,n)end function Y(n,e)W(g(n)or g(e))if(b(n))return w(n)
if(b(e))return w(e)
local o,f,d,t,i=n[1]==e[1]and"+"or"-",n[2],e[2],n[3],e[3]if t=="inf"then W(m(e,true)==0)return s({o,"0","inf"},e)elseif i=="inf"then W(m(n,true)==0)return s({o,"0","inf"},n)end local r,l,t,i="",t+i,{},0for e=1,#d,2do local n=1repeat i+=(t[n\2+e\2+1]or 0)+("0"..sub(f,-n-1,-n))*("0"..sub(d,-e-1,-e))t[n\2+e\2+1]=i%100i\=100n+=2until n>#f and i<=0end for n=1,#t do r=sub("0"..t[n],-2)..r end return C(s({o,r,l},n,e))end function I(n,t,u)W(g(n)or g(t))if(b(n))return w(n)
if(b(t))return w(t)
local a,h,e,d,o,i,l=n[4]\32*9-2,t[4]\32*9-2,n[2],t[2],n[3],t[3],n[1]==t[1]and"+"or"-"if o=="inf"then W(i=="inf")return s({l,"0","inf"},t)elseif i=="inf"then return s({l,"0",0},n)end local r,f,c,i=0,"",o-i,0if(m(t,true)==0)assert(m(n,true)~=0,"division undefined")return s({l,"0","inf"},n,t)
if m(n,true)==0or u and nu(n,t)then f="0"else while(F(e,d)<0)e..="0"o-=1r+=1
while(F(e,d.."0")>=0)d..="0"r-=1
f=""local n={[0]="0",d}while true do while F(n[i],e)<=0do i+=1if(not n[i])local r,o,t="",0,1repeat o+=("0"..sub(n[i-1],-t-3,-t))+("0"..sub(d,-t-3,-t))r=sub("000"..o%10000,-4)..r o\=10000t+=4until t>max(#n[i-1],#e)and o<=0n[i]=B(r)
end i-=1local l,d,t="",0,1repeat d+=("0"..sub(e,-t-3,-t))-("0"..sub(n[i],-t-3,-t))l=sub("000"..d%10000,-4)..l d\=10000t+=4until t>max(#e,#n[i])and d<=0e=B(l)f..=i if(e=="0"and r>=0or#f>min(a,h)or u and c<=r)break
i=0e..="0"o-=1r+=1end end local i=C(s({l,f,c-r},n,t))if u then for n=2,#f do if(y(e,-1)~="0")break
e=sub(e,1,-2)o+=1end return i,C(s({n[1],e,o},n,t))end return i end function n5(n,e)local e,n=X(n,e)return n end function n8(n,e)return H(n,e)==0end function nu(n,e)return H(n,e)<0end function nw(n,e)return H(n,e)<=0end function nb(n)return V(s({"+","0",0},n),n)end function nk(n)local n=w(n)W(g(n))if(b(n)or not U(n))return n
n[2]=n[3]<0and n[3]<=#n[2]and sub(n[2],n[3])or"0"return C(n)end function n9(n)local n=w(n)W(g(n))if(b(n)or not U(n))return n
if(n[3]<0)n[2],n[3]=sub(n[2],1,n[3]-1),0
if(n[2]=="")n[2]="0"
return C(n)end function K(n,r,i,f,o)local e,t="+"if O("-",n)then e,n="-",sub(n,2)if(o)return{}
elseif O("+",n)then n=sub(n,2)if(o)return{}
end if i then local e=split(n,"e",false)if#e==2then local i=K(e[2],true,false,true)if(#i>0)t,n=i[1],e[1]
end end if(n==".")return{}
if(n=="")return f and{}or{""}
if r then for e=1,#n do if(not tonum(y(n,e)))return{}
end if(i)return{e..n,"",t}
return{e..n}end local n=split(n,".",false)if(#n>2)return{}
return{e..n[1],n[2]or"",t}end function no(e)local o,t,i,n={"+","0","qnan"},"+",0,1if O("+",e)then t="+"n+=1elseif O("-",e)then t="-"n+=1end if(O("inf",e,n,true)or O("infinity",e,n,true))return{t,"0","inf"}
for i=1,2do if O(split"nan,snan"[i],e,n)then n+=i+2local n=K(sub(e,n),true,false,false,true)if(#n==0)return o
return{t,n[1]==""and"0"or sub(n[1],2),split"qnan,snan"[i]}end end local n=K(sub(e,n),false,true)if(#n<2)return o
return{t,B(sub(n[1],2)..n[2]),(n[3]or 0)-#n[2]}end function ng(n)for e=1,#n,32do print(sub(n,e,e+31))end end function n6(n)local e=stat(1)n()return stat(1)-e end function nc(n)if type(n)=="table"then local e="{ "for n,t in pairs(n)do if(type(n)~="number")n='"'..n..'"'
e=e.."["..n.."] = "..nc(t)..","end return e.."} "else return tostr(n)end end function nm(n,e,t)if n<e then return e elseif n>t then return t end return n end function n7(n)assert(#n==1)for n in all(n)do return n end end function n0(n,...)local n,e=cocreate(n),{...}return function()if(n and costatus(n)~="dead")local e,n=coresume(n,unpack(e))return n else return nil
end end function na(n,e)for n in all(n)do if(n==e)return true
end return false end function n1(n,e)L(n,1,#n,e)end function L(n,e,t,i)if(e<t)local o=nh(n,e,t,i)L(n,e,o-1,i)L(n,o+1,t,i)
end function nh(e,i,t,o)local r,n=e[t],i-1for t=i,t-1do if(o(e[t],r))n=n+1Z(e,n,t)
end Z(e,n+1,t)return n+1end function Z(n,e,t)n[e],n[t]=n[t],n[e]end function nn(n,e,t)if(n==0and e==0)return 0,0
if(t==nil)t=1
ne=sqrt(n*n+e*e)return n*t/ne,e*t/ne end P={}function P:new()local n={}setmetatable(n,self)self.__index=self n.values={}return n end function P:set(n,e)if(not self.values[n])self.values[n]={}
self.values[n][e]=true end function P:unset(n,e)if(not self.values[n])return
self.values[n][e]=nil if(not next(self.values[n]))self.values[n]=nil
end function P:is_set(n,e)if(not self.values[n])return false
return self.values[n][e]end j={max_panels_per_transformer=8,debug_timing=false,cow_speed=1}a={}p={solar_panel=17,transformer_left=18,transformer_right=19,cow_side=22,cow_looking=23,selection_box=32,pick_up=34,no_action=35,place_panel=33,place_wire=36,place_transformer=20,rock=48,wire_left=49,wire_right=50,wire_up=51,wire_down=52,grid_wire=54,tree_top=21,tree_bottom=37}function a.add(o,n,e,t,i)n=p[n]if(not e)e=1
if(not t)t=1
if(not i)i=0
function n2(o,r)a.draw_spr(n,o,r+i,e,t)end k.add(o,n2)end function nt(n)return flr(n*8)/8end function a.draw_spr(n,e,t,i,o,f)e=nt(e)t=nt(t)local d,l=c.get_location(u.ent_id)if(not i)i=1
if(not o)o=1
local r=false if fget(n,0)then palt(8192)r=true elseif fget(n,1)then palt(256)r=true end spr(n,(8+e-d)*8,(8+t-l)*8,i,o,f)if(r)palt()
end function a.set_pixel(n,e,t,i,o)local r,f=c.get_location(u.ent_id)pset((8+n-r)*8+t,(8+e-f)*8+i,o)end function a.rect(n,e,o,r,f,d,l)local t,i=c.get_location(u.ent_id)rect((8+n-t)*8+o,(8+e-i)*8+r,(8+n-t)*8+f,(8+e-i)*8+d,l)end k={fns={}}function k.add(n,e)k.fns[n]=e end function k.drawTileAt(n,e,t)if(not k.fns[n])return
k.fns[n](e,t,n)end e={current_entity_id=0}function e.create_entity()e.current_entity_id+=1return e.current_entity_id end d={locations={}}function d.place_entity(e,n,t)if not e then if(not d.locations[n])return
d.locations[n][t]=nil if(not next(d.locations[n]))d.locations[n]=nil
else if(not d.locations[n])d.locations[n]={}
d.locations[n][t]=e end end function d.remove_entity(n,e)d.place_entity(nil,n,e)end function d.entity_at(n,e)if(not d.locations[n])return nil
return d.locations[n][e]end function d.iterate_all_entity_locations(n)return n0(d._iterate_all_entity_locations_co,n)end function d._iterate_all_entity_locations_co(n)for e,t in pairs(d.locations)do for t,i in pairs(t)do if(n==nil or na(n,i))yield{e,t}
end end end c={xs={},ys={}}function c.set_or_update_location(n,e,t)c.xs[n]=e c.ys[n]=t end function c.get_location(n)return c.xs[n],c.ys[n]end function c.move_by_if_not_obstructed(n,e,t,i)e,t=nn(e,t,i)local i,o=c.xs[n],c.ys[n]local e,t=i+e,o+t if(not M.is_obstructed(e,o))c.xs[n]=e i=e
if(not M.is_obstructed(i,t))c.ys[n]=t
end function c.get_all_visible(n,t,r,f)local i={}for o,e in pairs(c.xs)do if n<=e and e<=t then local t=c.ys[o]if(r<=t and t<=f)local n={}n[1]=o n[2]=e n[3]=t add(i,n)
end end return i end l={attr={}}function l.set_attr(n,e,t)if(not l.attr[n])l.attr[n]={}
l.attr[n][e]=t end function l.set_attrs(n,...)for e,t in pairs(...)do l.set_attr(n,e,t)end end function l.get_attr(n,e)if(not l.attr[n])return nil
return l.attr[n][e]end function l.get_attr_by_location(n,e,t)local n=d.entity_at(n,e)if(n==nil)return nil
if(not l.attr[n])return nil
return l.attr[n][t]end v={last_cpu=0}function v.reset()v.last_cpu=0end function v.get_and_advance()local n=stat(1)local e=n-v.last_cpu v.last_cpu=n return e end N={last_t=0}function N.calculate_elapsed()local n=1/60return n end f={sel_x_p=0,sel_y_p=0,sel_x=0,sel_y=0,sel_sprite="no_action",is_placing=nil,is_removing=nil,placeable_entities=nil,placeable_index=1,place_ent_id=nil,placement_fns={},removal_fns={},obstructed_fns={}}function f.init()f.placeable_entities={h.ent_id,_.ent_id,o.ent_left}f.place_ent_id=f.placeable_entities[f.placeable_index]end function f.get_name()return"Placement"end function f.update(n)f.handle_selection_and_placement()end function f.set_placement_fn(n,e)f.placement_fns[n]=e end function f.set_removal_fn(n,e)f.removal_fns[n]=e end function f.set_placement_obstruction_fn(n,e)f.obstructed_fns[n]=e end function f.draw()a.draw_spr(p["selection_box"],f.sel_x,f.sel_y)a.draw_spr(p[f.sel_sprite],f.sel_x,f.sel_y-1)end function f.rotate_place_ent_id()f.placeable_index%=#f.placeable_entities f.placeable_index+=1f.place_ent_id=f.placeable_entities[f.placeable_index]end function f.remove(n,e,t)local i=f.removal_fns[n]if i then local e=i(e,t)if(e)n=e
else d.remove_entity(e,t)end f.is_removing=n f.place_ent_id=n q.recalculate()end function f.place(n,e,t)f.is_placing=n f.place_ent_id=n local i=f.placement_fns[n]if(i)i(e,t)else d.place_entity(n,e,t)
q.recalculate()end function f.handle_selection_and_placement()if(btnp(🅾️))f.rotate_place_ent_id()
local n=d.entity_at(f.sel_x,f.sel_y)local n,e,t=f.determine_action_and_sprite(n)f.sel_sprite=t if(btn(❎))if n=="no_action"then elseif n=="pick_up"then f.remove(e,f.sel_x,f.sel_y)elseif n=="place"then f.place(e,f.sel_x,f.sel_y)else assert(false)end else f.is_placing=nil f.is_removing=nil
end function f.determine_action_and_sprite(n)if n==nil then if f.is_removing then return"no_action",nil,"pick_up"else local n=f.obstructed_fns[f.place_ent_id]if(n and n(f.sel_x,f.sel_y))return"no_action",nil,"no_action"
return"place",f.place_ent_id,l.get_attr(f.place_ent_id,"placement_sprite")end end if(n==f.is_placing)return"no_action",nil,l.get_attr(n,"placement_sprite")
if(n==f.is_removing)return"pick_up",n,"pick_up"
if(not f.is_placing and not f.is_removing and l.get_attr(n,"removable"))return"pick_up",n,"pick_up"
return"no_action",nil,"no_action"end M={}function M.get_name()return"World"end function M.draw()local n,i=c.get_location(u.ent_id)local o,r,t,f=flr(n-10),flr(n+8),flr(i-9),flr(i+9)local n=c.get_all_visible(o,r,t,f)M._sort_by_y(n)local e=1for t=t,f do for n=o,r do local e=d.entity_at(n,t)if(e)k.drawTileAt(e,n,t)
end if(t==flr(i+.4))u.drawChar()
if next(n)then while(n[e]and t>=flr(n[e][3]+.4))k.drawTileAt(n[e][1],n[e][2],n[e][3])e+=1
end end end function M._sort_by_y(n)function ns(n,e)return n[3]<e[3]end n1(n,ns)end function M.is_obstructed(n,e)return l.get_attr_by_location(flr(n+.6),flr(e+1),"WalkingObstruction")end Q={}function Q.get_name()return"Map"end function Q.draw()local n,e=c.get_location(u.ent_id)map(0,0,(flr(n)-n)*8,(flr(e)-e)*8,17,17)end i={powered_panel_count=0,capacity=0,total_generated=0,earning=0,earned=0}function i.init()i.capacity=x{"+","0",0}i.total_generated=x{"+","0",0}i.earning=x{"+","0",0}i.earned=x{"+","0",0}end function i.get_name()return"PanelCalculator"end function n(e,n)if(not n)n=10
return sub(nl(e),1,n)end function i.draw()color(6)print("capacity: "..n(i.capacity).."000 watts")print("total: "..n(i.total_generated,6).." watt-hours")print("earning: $"..n(i.earning).."/h")print("earned: $"..n(i.earned))end function i.update(n)local e,n=i.powered_panel_count,I(x(n),x(3600))i.capacity=x(e)i.total_generated=J(i.total_generated,Y(n,i.capacity))i.earning=I(i.capacity,x"20000")i.earned=J(i.earned,Y(n,i.earning))end function i.set_powered_panel_count(n)i.powered_panel_count=n end q={}function q.recalculate()local n,e=q.get_connected_components()q.mark_powered_transformers(n)q.mark_powered_panels(e)end function q.get_name()return"Circuits"end function q.mark_powered_panels(n)h.clear_powered()local e=0for n in all(n)do local t,i=0,0if n[o.ent_right]then for e,t in pairs(n[o.ent_right])do for t,i in pairs(t)do if i then if(not n[o.ent_left])n[o.ent_left]={}
if(not n[o.ent_left][e-1])n[o.ent_left][e-1]={}
if(not n[o.ent_left][e-1][t])n[o.ent_left][e-1][t]={}
n[o.ent_left][e-1][t]=true end end end end if n[o.ent_left]then for n,e in pairs(n[o.ent_left])do for e,i in pairs(e)do if i then if(o.is_powered(n,e))t+=1
end end end end if n[h.ent_id]then for e,n in pairs(n[h.ent_id])do for e,n in pairs(n)do if(n)i+=1
end end if i/t<=j.max_panels_per_transformer then for n,t in pairs(n[h.ent_id])do for t,i in pairs(t)do if i then if(not h.is_powered(n,t))h.mark_powered(n,t)e+=1
end end end else for n,e in pairs(n[o.ent_left])do for e,t in pairs(e)do if(t)o.mark_overloaded(n,e)
end end end end end i.set_powered_panel_count(e)end function q.mark_powered_transformers(n)o.clear_powered()for n in all(n)do for n,e in pairs(n[o.ent_left])do for e,t in pairs(e)do if(t)o.mark_powered(n,e)
end end for n,e in pairs(n[o.ent_right])do for e,t in pairs(e)do if(t)o.mark_powered(n-1,e)
end end end end function q.get_connected_components()local n,e,o,t={},{},P:new(),{}function E(n,i)if(o:is_set(n,i))return
local e=d.entity_at(n,i)if e~=nil then if l.get_attr(e,"is_circuit_component")then if(not t[e])t[e]={}
if(not t[e][n])t[e][n]={}
if(not t[e][n][i])t[e][n][i]={}
t[e][n][i]=true elseif e==_.ent_id or e==D.ent_id then o:set(n,i)E(n-1,i)E(n+1,i)E(n,i-1)E(n,i+1)end end end function ni(i,n)for n in d.iterate_all_entity_locations(n)do local e,n=n[1],n[2]if not o:is_set(e,n)then E(e,n)if(next(t)~=nil)add(i,t)
t={}end end end ni(n,{D.ent_id})ni(e,{_.ent_id})return n,e end u={ent_id=nil,frame=1,speed=6,anim_speed=8,anim_frames={1,2},flip_x=false,is_moving=false}function u.init()u.ent_id=e.create_entity()c.set_or_update_location(u.ent_id,0,0)end function u.get_name()return"Character"end function u.update(n)u.handle_player_movement(n)end function u.drawChar()local n=u.anim_frames[1+flr(u.frame)%#u.anim_frames]spr(n,64,64,1,1,u.flip_x)end function u.handle_player_movement(r)local e,t,n=0,0,false if(btn(⬅️))u.flip_x=true u.anim_frames={1,2}e=-1n=true
if(btn(➡️))u.anim_frames={1,2}u.flip_x=false e=1n=true
if btn(⬆️)then u.anim_frames={3,4}t=-1n=true if(btn(⬅️)or btn(➡️))u.anim_frames={9,10}
end if btn(⬇️)then u.anim_frames={7,8}t=1n=true if(btn(⬅️)or btn(➡️))u.anim_frames={5,6}
end local i=false if(n and not u.is_moving)i=true
u.is_moving=n local n,o=2,12if(i)e=e/2t=t/2else e,t=nn(e,t,o*r)
f.sel_x_p+=e f.sel_y_p+=t local e,t=c.get_location(u.ent_id)local i,o=0,0if f.sel_x_p>e+n+.5then i=1f.sel_x_p=e+n+.5elseif f.sel_x_p<e-n+.5then i=-1f.sel_x_p=e-n+.5end if f.sel_y_p>t+n+.5then o=1f.sel_y_p=t+n+.5elseif f.sel_y_p<t-n+.5then o=-1f.sel_y_p=t-n+.5end f.sel_x=flr(f.sel_x_p)f.sel_y=flr(f.sel_y_p)c.move_by_if_not_obstructed(u.ent_id,i,o,u.speed*r)if(i~=0or o~=0)u.frame+=u.anim_speed*r else u.frame=.99
end h={ent_id=nil,powered_panels=nil}function h.init()h.ent_id=e.create_entity()h.clear_powered()l.set_attrs(h.ent_id,{WalkingObstruction=true,removable=true,is_circuit_component=true,placement_sprite="place_panel",pluggable=true})k.add(h.ent_id,h.draw_panel)end function h._panel_at(n,e)return d.entity_at(n,e)==h.ent_id end function h.clear_powered()h.powered_panels=P:new()end function h.mark_powered(n,e)h.powered_panels:set(n,e)end function h.is_powered(n,e)return h.powered_panels:is_set(n,e)end function h.draw_panel(n,e)a.draw_spr(p["solar_panel"],n,e)if(h.powered_panels:is_set(n,e))a.set_pixel(n,e,4,4,11)
end z={ent_id=nil}function z.init()z.ent_id=e.create_entity()l.set_attr(z.ent_id,"WalkingObstruction",true)a.add(z.ent_id,"rock")for n=1,500do local n,e=flr(rnd(100))-50,flr(rnd(100))-50d.place_entity(z.ent_id,n,e)end end A={ent_id=nil}function A.init()A.ent_id=e.create_entity()l.set_attr(A.ent_id,"WalkingObstruction",true)a.add(A.ent_id,"tree_top",1,2,-1)for n=1,500do local n,e=flr(rnd(100))-50,flr(rnd(100))-50d.place_entity(A.ent_id,n,e)end end r={cow_ent_ids={},vector_x={},vector_y={},flip_x={},looking={}}function r.init()for n=1,100do local n=e.create_entity()add(r.cow_ent_ids,n)k.add(n,r.draw_cow)local e,t=flr(rnd(100))-50,flr(rnd(100))-50c.set_or_update_location(n,e,t)r.vector_x[n]=0r.vector_y[n]=0r.flip_x[n]=rnd()>.5r.looking[n]=false end end function r.draw_cow(t,i,n)local e=p["cow_side"]if(r.looking[n])e=p["cow_looking"]
a.draw_spr(e,t,i,1,1,r.flip_x[n])end function r.update(e)for n in all(r.cow_ent_ids)do if(rnd(100)<1and r.vector_x[n]==0and r.vector_y[n]==0)r.looking[n]=true
if(rnd(100)<1)r.looking[n]=false
if(rnd(100)<1)r.vector_x[n]=0r.vector_y[n]=0
if rnd(100)<1then r.looking[n]=false local e=rnd(2)-1if(e>0)r.flip_x[n]=true else r.flip_x[n]=false
r.vector_x[n]=e r.vector_y[n]=rnd(2)-1end c.move_by_if_not_obstructed(n,r.vector_x[n],r.vector_y[n],j.cow_speed*e)end end _={ent_id=nil}function _.init()_.ent_id=e.create_entity()l.set_attrs(_.ent_id,{removable=true,placement_sprite="place_wire",pluggable=true})k.add(_.ent_id,_.draw_wire_tile)end function _.is_pluggable(n,e)return l.get_attr_by_location(n,e,"pluggable")end function _.draw_wire_tile(n,e)local t,i,o,r=_.is_pluggable(n-1,e),_.is_pluggable(n+1,e),_.is_pluggable(n,e-1),_.is_pluggable(n,e+1)if(not o and not r)a.draw_spr(p["wire_left"],n,e)a.draw_spr(p["wire_right"],n,e)return
if(not t and not i)a.draw_spr(p["wire_up"],n,e)a.draw_spr(p["wire_down"],n,e)return
if(o)a.draw_spr(p["wire_up"],n,e)
if(t)a.draw_spr(p["wire_left"],n,e)
if(i)a.draw_spr(p["wire_right"],n,e)
if(r)a.draw_spr(p["wire_down"],n,e)
end o={ent_left=nil,ent_right=nil,powered_transformers=nil,overloaded_transformers=nil}function o.init()o.ent_left=e.create_entity()o.ent_right=e.create_entity()o.clear_powered()l.set_attrs(o.ent_left,{WalkingObstruction=true,placement_sprite="place_transformer",removable=true,is_circuit_component=true,pluggable=true})l.set_attrs(o.ent_right,{WalkingObstruction=true,removable=true,is_circuit_component=true,pluggable=true})k.add(o.ent_left,o.draw_transformer)f.set_placement_fn(o.ent_left,o.place)f.set_removal_fn(o.ent_left,o.remove_left)f.set_removal_fn(o.ent_right,o.remove_right)f.set_placement_obstruction_fn(o.ent_left,o.placement_obstructed)end function o.clear_powered()o.powered_transformers=P:new()o.overloaded_transformers=P:new()end function o.mark_powered(n,e)o.powered_transformers:set(n,e)o.powered_transformers:set(n+1,e)end function o.mark_overloaded(n,e)o.overloaded_transformers:set(n,e)o.overloaded_transformers:set(n+1,e)end function o.is_powered(n,e)return o.powered_transformers:is_set(n,e)end function o.is_overloaded(n,e)return o.overloaded_transformers:is_set(n,e)end function o.place(n,e)d.place_entity(o.ent_left,n,e)d.place_entity(o.ent_right,n+1,e)end function o.remove_left(n,e)d.remove_entity(n,e)d.remove_entity(n+1,e)end function o.remove_right(n,e)d.remove_entity(n-1,e)d.remove_entity(n,e)return o.ent_left end function o.placement_obstructed(n,e)if(d.entity_at(n+1,e))return true
return false end function o.draw_transformer(n,e)a.draw_spr(p["transformer_left"],n,e,2,1)if o.is_overloaded(n,e)then a.set_pixel(n,e,5,5,8)elseif o.is_powered(n,e)then a.set_pixel(n,e,5,5,11)end end D={ent_id=nil}function D.init()D.ent_id=e.create_entity()l.set_attrs(D.ent_id,{WalkingObstruction=true,pluggable=true})a.add(D.ent_id,"grid_wire")for n=-100,100do d.place_entity(D.ent_id,n,10)end end R={systems={z,A,h,_,D,o,Q,M,r,f,u,N,i}}function _init()srand(12345)for n in all(R.systems)do if(n.init)n.init()
end q.recalculate()end function _draw()cls()if(j.debug_timing)printh("Drawing; start "..tostr(v.get_and_advance()))
for n in all(R.systems)do if n.draw then n.draw()if(j.debug_timing)printh(n.get_name()..".draw(): "..tostr(v.get_and_advance()))
end end end function _update60()local e=N.calculate_elapsed()if(j.debug_timing)v.reset()printh""printh("Updating; start "..tostr(v.get_and_advance()))
for n in all(R.systems)do if n.update then n.update(e)if(j.debug_timing)printh(n.get_name()..".update(): "..tostr(v.get_and_advance()))
end end end
__gfx__
00000000000000000044440000000000004440000000000000444400000000000044400000000000004444000000000000000000000000000000000000000000
000000000044440000444f000044400004444400004444000044f40000444000044f440000444400044444000000000000000000000000000000000000000000
0070070000444f00044f1f0004444400044444000044f4000441f100044f4400041f14000444440004444f000000000000000000000000000000000000000000
00077000044f1f00044fff0004444400044444000441f100044fff00041f140004fff40004444f0004444f000000000000000000000000000000000000000000
00077000044fff0000eee0000444440000444000044fff0000eee00004fff40004eee40004444f000044e0000000000000000000000000000000000000000000
0070070000eee00000dfd0000044400000d4d00000eee00000fddf0004eee4000fdddf000044e000004ddf000000000000000000000000000000000000000000
0000000000fdd0000d000d0000d4d00000d0d00000fddf000d000d000fdddf0000d0d000004ddf000d000d000000000000000000000000000000000000000000
0000000000d0d0000000000000d0d0000000000000d0d0000000000000d0d0000000000000d0d000000000000000000000000000000000000000000000000000
33333333000700002222222222222222222222227770007722222222222222220000000000000000000000000000000000000000000000000000000000000000
33b33333007c700022666222222666222222222270033b0707000007700070070000000000000000000000000000000000000000000000000000000000000000
533333b307ccc700222022666622022222222222033333b007771170077701700000000000000000000000000000000000000000000000000000000000000000
333533337cc7cc70220066200266002222266222053333b000771170007001700000000000000000000000000000000000000000000000000000000000000000
3333b33307cc1cc7220666666666602226200262053333b007777710077707100000000000000000000000000000000000000000000000000000000000000000
33333333017ccc702206616666cc60222066c602003333300e07777020e077700000000000000000000000000000000000000000000000000000000000000000
b33333330107c7002208888888888022208888020333330020070e7022070e700000000000000000000000000000000000000000000000000000000000000000
33533b330000700022000000000000222000000205333bb022202202222022020000000000000000000000000000000000000000000000000000000000000000
aa0000aa00000000000000000000000022222222053333b000000000000000000000000000000000000000000000000000000000000000000000000000000000
a000000a000000000000000000000000222222220533333000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000222222227053300700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000222222227700007700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000007000000008000000000000222222227704907700000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000007c700000088800000808000288888227024490700000000000000000000000000000000000000000000000000000000000000000000000000000000
a000000a017c70000808080000080000200000227702007700000000000000000000000000000000000000000000000000000000000000000000000000000000
aa0000aa010700000008000000808000222222227770777700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000222222222222222222208222222222220000000022222222000000000000000000000000000000000000000000000000000000000000000000000000
00000000222222222222222222208222222222220000000022222222000000000000000000000000000000000000000000000000000000000000000000000000
00666600222222222222222222208222222222220000000022222222000000000000000000000000000000000000000000000000000000000000000000000000
065655608888822222228888222082222222822200000000aaaaaaaa000000000000000000000000000000000000000000000000000000000000000000000000
05566660000022222220000022202222222082220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11556650222222222222222222222222222082220000000022222222000000000000000000000000000000000000000000000000000000000000000000000000
11155500222222222222222222222222222082220000000022222222000000000000000000000000000000000000000000000000000000000000000000000000
00000000222222222222222222222222222082220000000022222222000000000000000000000000000000000000000000000000000000000000000000000000
__map__
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1010101010101010101010101010101010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__gff__
0000000000000000000000000000000000000101010201010000000000000000000000000102000000000000000000000001010101000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__meta:title__
decimal floating point library
for pico-8
