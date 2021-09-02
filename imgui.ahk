#NoEnv

PATH_OVERLAY := xfhhntfhdnchnctndnrhnt_RelToAbs(A_ScriptDir, "imgui.dll")
hModule := DllCall("LoadLibrary", "Str", PATH_OVERLAY, "Ptr")
if(hModule == -1 || hModule == 0)
{
    MsgBox, 48, Error, The imgui.dll couldn't be loaded!
    ExitApp
}

Global GUICreate_func        := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "GUICreate", "Ptr")
Global PeekMsg_func          := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "PeekMsg", "Ptr")
Global BeginFrame_func       := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "BeginFrame", "Ptr")
Global Begin_func            := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "Begin", "Ptr")
Global Text_func             := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "Text", "Ptr")
Global End_func              := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "End", "Ptr")
Global EndFrame_func         := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "EndFrame", "Ptr")
Global RadioButton_func      := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "RadioButton", "Ptr")
Global Checkbox_func         := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "Checkbox", "Ptr")
Global EnableViewports_func  := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "EnableViewports", "Ptr")
Global SameLine_func         := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "SameLine", "Ptr")
Global NewLine_func          := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "NewLine", "Ptr")
Global SetWindowPosition_func:= DllCall("GetProcAddress", "Ptr", hModule, "AStr", "SetWindowPosition", "Ptr")
Global SetWindowSize_func    := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "SetWindowSize", "Ptr")
Global SliderInt_func        := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "SliderInt", "Ptr")
Global SliderFloat_func      := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "SliderFloat", "Ptr")
Global SliderAngle_func      := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "SliderAngle", "Ptr")
Global ColorPicker_func      := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "ColorPicker", "Ptr")
Global BeginTooltip_func     := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "BeginTooltip", "Ptr")
Global EndTooltip_func       := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "EndTooltip", "Ptr")
Global Button_func           := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "Button", "Ptr")
Global VSliderInt_func       := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "VSliderInt", "Ptr")
Global Columns_func          := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "Columns", "Ptr")
Global NextColumn_func       := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "NextColumn", "Ptr")
Global PushItemWidth_func    := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "PushItemWidth", "Ptr")
Global BeginChild_func       := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "BeginChild", "Ptr")
Global ColorEdit_func        := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "ColorEdit", "Ptr")
Global CheckboxFlags_func    := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "CheckboxFlags", "Ptr")
Global EndChild_func         := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "EndChild", "Ptr")
Global BeginTabBar_func      := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "BeginTabBar", "Ptr")
Global EndTabBar_func        := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "EndTabBar", "Ptr")
Global BeginTabItem_func     := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "BeginTabItem", "Ptr")
Global EndTabItem_func       := DllCall("GetProcAddress", "Ptr", hModule, "AStr", "EndTabItem", "Ptr")








_ImGui_GUICreate(title, w, h, x, y) {
	Return DllCall(GUICreate_func, "wstr", title, "int", w, "int", h, "int", x, "int", y, "Ptr")
}

_ImGui_PeekMsg() {
	Return DllCall(PeekMsg_func)
}

_ImGui_BeginFrame() {
	DllCall(BeginFrame_func)
}

_ImGui_Begin(title, close_btn := False, flags := 0) {
	if close_btn {
		VarSetCapacity(b_close, 1)
		,NumPut(1, b_close, 0x0, "UChar")
	}
	if close_btn
		Return 1
	DllCall(Begin_func, "wstr", title, "ptr", &b_close, "int", 0)
}

_ImGui_Text(text) {
	DllCall(Text_func, "wstr", text)
}

_ImGui_End() {
	DllCall(End_func)
}

_ImGui_EndFrame(color) {
	DllCall(EndFrame_func, "uint", color)
}

_ImGui_RadioButton(label, ByRef v, v_button) {
	VarSetCapacity(struct_v, 4)
	,NumPut(v, struct_v, 0x0, "int")
	,result := DllCall(RadioButton_func, "wstr", label, "Ptr", &struct_v, "int", v_button)
	,v := NumGet(struct_v, 0x0, "int")
	Return result
}

_ImGui_Checkbox(text, ByRef active) {
	VarSetCapacity(b_active, 1)
	,NumPut(active, b_active, 0x0, "UChar")
	,result := DllCall(Checkbox_func, "wstr", text, "ptr", &b_active)
	,active := NumGet(b_active, 0x0, "UChar")
	Return result
}

_ImGui_EnableViewports(enable := 1) {
	DllCall(EnableViewports_func, "UChar", enable)
}

_ImGui_SameLine(offset_from_start_x := 0, spacing_w := -1) {
	DllCall(SameLine_func, "float", offset_from_start_x, "float", spacing_w)
}

_ImGui_NewLine() {
	DllCall(NewLine_func)
}

_ImGui_SetWindowPos(pos_x, pos_y, cond:=0) {
	DllCall(SetWindowPosition_func, "float", pos_x, "float", pos_y, "int", cond)
}

_ImGui_SetWindowSize(size_x, size_y, cond:=0) {
	DllCall(SetWindowSize_func, "float", size_x, "float", size_y, "int", cond)
}

_ImGui_SliderInt(label, ByRef v, v_min, v_max, format := "%d") {
	VarSetCapacity(struct, 4)
	,NumPut(v, struct, 0x0, "int")
	,result := DllCall(SliderInt_func, "wstr", label, "ptr", &struct, "int", v_min, "int", v_max, "wstr", format)
	,v := NumGet(struct, 0x0, "int")
	Return result
}

_ImGui_SliderFloat(text, ByRef v, v_min, v_max, format := "%.3f", power := 1) {
	VarSetCapacity(struct, 4)
	,NumPut(v, struct, 0x0, "Float")
	,result := DllCall(SliderFloat_func, "wstr", text, "ptr", &struct, "Float", v_min, "Float", v_max, "wstr", format, "Float", power)
	,v := NumGet(struct, 0x0, "Float")
	Return result
}

_ImGui_SliderAngle(label, ByRef v_rad, v_degrees_min := -360, v_degrees_max := 360, format := "%.0f deg") {
	VarSetCapacity(struct_v_rad, 4)
	,NumPut(v_rad, struct_v_rad, 0x0, "Float")
	,result := DllCall(SliderAngle_func, "wstr", label, "ptr", &struct_v_rad, "float", v_degrees_min, "float", v_degrees_max, "wstr", format)
	,v_rad := NumGet(struct_v_rad, 0x0, "Float")
	Return result
}

_ImGui_ColorPicker(label, ByRef color, flags := 0) {
	VarSetCapacity(struct_v, 4)
	,NumPut(color, struct_v, 0x0, "Uint")
	,result := DllCall(ColorPicker_func, "wstr", label, "ptr", &struct_v, "int", flags)
	,color := NumGet(struct_v, 0x0, "Uint")
	Return result
}

_ImGui_BeginTooltip() {
	DllCall(BeginTooltip_func)
}

_ImGui_EndTooltip() {
	DllCall(EndTooltip_func)
}

_ImGui_ToolTip(text) {
	_ImGui_BeginTooltip()
	_ImGui_Text(text)
	_ImGui_EndTooltip()
}

_ImGui_Button(text, w := 0, h := 0) {
	DllCall(Button_func, "wstr", text, "float", w, "float", h)
}

_ImGui_VSliderInt(label, size_x, size_y, ByRef v, v_min, v_max, format := "%d") {
	VarSetCapacity(struct_v, 4)
	,NumPut(v, struct_v, 0x0, "int")
	,result := DllCall(VSliderInt_func, "wstr", label, "float", size_x, "float", size_y, "ptr", &struct_v, "int", v_min, "int", v_max, "wstr", format)
	,v := NumGet(struct_v, 0x0, "int")
	Return result
}

_ImGui_Columns(columns_count := 1, id := "", border := true) {
	DllCall(Columns_func, "int", columns_count, "wstr", id, "Char", border)
}

_ImGui_NextColumn() {
	DllCall(NextColumn_func)
}

_ImGui_PushItemWidth(item_width) {
	DllCall(PushItemWidth_func, "float", item_width)
}

_ImGui_BeginChild(text, w := 0, h := 0, border := False, flags := 0) {
	DllCall(BeginChild_func, "wstr", text, "float", w, "float", h, "Char", border, "int", flags)
}

_ImGui_ColorEdit(label, ByRef color, flags := 0) {
	VarSetCapacity(struct_v, 4)
	,NumPut(color, struct_v, 0x0, "Uint")
	,result := DllCall(ColorEdit_func, "wstr", label, "ptr", &struct_v, "int", flags)
	,color := NumGet(struct_v, 0x0, "int")
	Return result
}

_ImGui_CheckboxFlags(label, ByRef flags, flags_value) {
	VarSetCapacity(struct_flags, 4)
	,NumPut(flags, struct_flags, 0x0, "Uint")
	,result := DllCall(CheckboxFlags_func, "wstr", label, "ptr", &struct_flags, "uint", flags_value)
	,flags := NumGet(struct_flags, 0x0, "int")
	Return result
}

_ImGui_EndChild() {
	DllCall(EndChild_func)
}

_ImGui_BeginTabBar(str_id, flags := 0) {
	Return DllCall(BeginTabBar_func, "wstr", str_id, "int", flags)
}

_ImGui_EndTabBar() {
	DllCall(EndTabBar_func)
}

_ImGui_BeginTabItemEx(label, ByRef p_open, flags := 0) {
	VarSetCapacity(struct_p_open, 1)
	,NumPut(p_open, struct_p_open, 0x0, "UChar")
	,result = DllCall(BeginTabItem_func, "wstr", label, "ptr", &struct_p_open, "int", flags)
	,p_open := NumGet(struct_p_open, 0x0, "UChar")
	Return result
}

_ImGui_BeginTabItem(label, flags := 0) {
	Return DllCall(BeginTabItem_func, "wstr", label, "ptr", 0, "int", flags)
}

_ImGui_EndTabItem() {
	DllCall(EndTabItem_func)
}



xfhhntfhdnchnctndnrhnt_RelToAbs(root, dir, s = "\") {
    pr := SubStr(root, 1, len := InStr(root, s, "", InStr(root, s . s) + 2) - 1)
        , root := SubStr(root, len + 1), sk := 0
    If InStr(root, s, "", 0) = StrLen(root)
        StringTrimRight, root, root, 1
    If InStr(dir, s, "", 0) = StrLen(dir)
        StringTrimRight, dir, dir, 1
    Loop, Parse, dir, %s%
    {
        If A_LoopField = ..
            StringLeft, root, root, InStr(root, s, "", 0) - 1
        Else If A_LoopField =
            root =
        Else If A_LoopField != .
            Continue
        StringReplace, dir, dir, %A_LoopField%%s%
    }
    Return, pr . root . s . dir
}