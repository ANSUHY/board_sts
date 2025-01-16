<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<jsp:include page="./common/head.jsp"></jsp:include>
		<script type="text/javascript">
			let actionUrl = $("input[name=actionUrl]", opener.document).val();

			/* 비밀번호 체크 */
			function chkPwd() {
				$.ajax({
					url: "/chkPwd",
					method: "POST",
					data: {
						board_no : $("input[name=board_no]", opener.document).val(),
						password : $("#password").val()
					},
					success: function (data) {
						if(actionUrl == "delete") {
							if(confirm("삭제하시겠습니까?")) {
								if (data == true) { // 비밀번호 일치
									getValue();
								} else { // 비밀번호 불일치
									alert("비밀번호가 일치하지 않습니다.");
								}
							}
						} else {
							getValue();
						}
					}
				});
			}

			/* 값 가져오기 */
			function getValue() {
				$("#detailFrm", opener.document).attr("action", actionUrl); // detail.jsp의 id가 detailFrm의 속성 action을 /edit으로 설정
				$("#detailFrm", opener.document).attr("target", opener.name); // detail.jsp의 id가 detailFrm의 속성 target을 opener.name으로 설정 -> 부모창 submit
				$("#detailFrm", opener.document).attr("method", "post"); // detail.jsp의 id가 detailFrm의 속성 method를 post로 설정
				$("#detailFrm", opener.document).submit(); // submit

				self.close(); // 팝업 닫기
			}
		</script>
	</head>

	<body>
		<div id="pop-wrap">
			<h1 class="pop-tit">비밀번호 확인</h1>
			<div class="pop-con">
				<table class="view">
					<colgroup>
						<col style="width: 100px" />
						<col />
					</colgroup>
					<tbody>
						<tr>
							<th>비밀번호</th>
							<td>
								<input type="password" id="password" class="input" style="width: 200px" />
								<input type="hidden" name="mthd" value="${mthd}">
								<a href="javascript:void(0);" onclick="chkPwd()" class="btn btn-red">확인</a>
							</td>
						</tr>
					</tbody>
				</table>

			<div class="btn-box">
				<a href="javascript:self.close();" class="btn btn-default">닫기</a>
			</div>
			</div>
			<!-- /pop-con -->
		</div>
		<!-- /pop-wrap -->
	</body>
</html>
