개선 사항

1. 등록일 -> 시작일로 변경
2. 필터 생성(어느 파트의 task인지 알 수 있게)
3. 완수일 추가(옵션)
4. 링크 추가 => 유효하지 않은 링크는 X, 누르면 링크 접속

models.py , form.py
- start_date , filter, link_path추가
- link_path는 form에서는 link로 사용

task_list
- filter, start_date, link 컬럼에 추가(th)
- 목록에 추가(td)
- [filter] <td class="text-left">{{ task.filter }}</td>
- [start_date] <td class="text-left">{{ task.start_date.strftime('%Y-%m-%d') }}</td>
- [link] <td class="text-left">
        {% if task.link_path %}
          <a href="{{ task.link_path }}" class="btn btn-info btn-sm" target="_blank">Link</a>
          <!-- target="_blank": 링크를 클릭했을 때 새 브라우저 탭이나 창에서 열리도록 설정 -->
        {% endif %}
      </td>   

add_task
- filter, start_date, link 추가
- [filter]   <div class="form-group">
    <label for="filter">필터</label>
    <select name="filter" id="filter" class="form-control">
      <option value="db">DB</option>
      <option value="python">파이썬</option>
      <option value="web">웹</option>
      <option value="deeplearning">딥러닝</option>
      <option value="machinelearning">머신러닝</option>
  </select>
  </div>
- [start_date]   <div class="form-group">
    <label for="start_date">시작일</label>
    <input type="date" name="start_date" id="start_date" class="form-control" required />
  </div>
- [link]  <div class="form-group">
    <label for="link">관련 링크</label>
    <input type="link" name="link" id="link" class="form-control" />
  </div>

edit_task
- filter, start_date, link 추가
- [filter] <div class="form-group">
    <label for="filter">필터</label>
    <select id="filter" name="filter" class="form-control">
      <option value="db" {% if task.filter == 'db' %}selected{% endif %}>DB</option>
      <option value="python" {% if task.filter == 'python' %}selected{% endif %}>파이썬</option>
      <option value="web" {% if task.filter == 'web' %}selected{% endif %}>웹</option>
      <option value="deeplearning" {% if task.filter == 'deeplearning' %}selected{% endif %}>딥러닝</option>
      <option value="machinelearning" {% if task.filter == 'machinelearning' %}selected{% endif %}>머신러닝</option>
    </select>
  </div>
- [start_date] <div class="form-group">
    <label for="start-date">시작일</label>
    <input type="date" name="start-date" id="start-date" class="form-control" value="{{ task.start_date }}" required />
  </div>
- [link] <div class="form-group">
    <label for="link">관련 링크</label>
    <input type="url" name="link" id="link" class="form-control" value="{{ task.link_path }}" />
    {% if task.link_path %}
    <p>현재 링크: <a href="{{ task.link_path }}" target="_blank">{{ task.link_path }}</a></p>
    <label for="remove_link">기존 링크 삭제</label>
    <input type="checkbox" name="remove_link" id="remove_link" />
    {% endif %}
  </div>

 => 기존 링크 삭제 체크박스를 누르고 edit을 하면 링크 삭제

 app.py
 - task_list, add_list, edit_list 수정

 - [task_list]
 "filter":task.filter
 "start_date": task.start_date
 "link_path":task.link_path

 - [add_list]
 filter, start_date, link추가

 - [edit_list]
 filter, start_date, link 추가

 [link 삭제 원할시]
  if "remove_link" in request.form:
            task.link_path = None
        else:
            task.link_path = form.link.data
