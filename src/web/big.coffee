BigCtrl = ($scope, $http) ->
	# Test.
	$scope.hello = 'Hola!'

	# Retrieve the json.
	$http.get '/data/newport10k.json'
		.success (data, status, headers, config) ->
			$scope.runners = data
			
			# In order to plot the amount of male/female, reduce + map.
			gender = _.countBy data, (runner) ->
				return runner.Gender
			gender = [
					label: 'Men'
					value: gender.M
				,
					label: 'Women'
					value: gender.F
			]
			plotPieChart 'Gender', gender, '#d3-gender-pie'

	# Plot pie chart.
	plotPieChart = (title, data, elementID) ->
		# DOM element.
		svg = d3
			.select elementID
			.data [data]
		element = angular.element svg[0]

		# Retrieve the element size.
		width = element.attr 'width'
		height = element.attr 'height'
		radius = Math.min(width, height) / 2

		# Color.
		color = d3.scale.category10()

		# Donut.
		donut = d3.layout.pie()
			.value (d) ->
				return d.value
			.sort null

		# Arc.
		arc = d3.svg.arc()
			.innerRadius radius - 100
			.outerRadius radius - 20

		# Translate to center.
		translate = 'translate(' + width / 2 + ',' + height / 2 + ')'

		# Group 1: pie chart.
		arc_group = svg
			.append 'g'
			.attr 'transform', translate

		# Path.
		path = arc_group
			.selectAll 'path'
			.data donut data
			.enter()
			.append 'path'
			.attr 'fill', (d, i) ->
				color i
			.attr 'd', arc

		# Group 2: pie labels.
		labels_group = svg
			.append 'g'
			.attr 'transform', translate

		# Pie labels.
		sliceLabel = labels_group
			.selectAll 'text'
			.data donut data
		sliceLabel
			.enter()
			.append 'text'
			.attr 'transform', (d, i) ->
				return 'translate(' + arc.centroid(d) + ')'
			.attr 'text-anchor', 'middle'
			.text (d, i) ->
				return d.data.label

		# Group 3: pie title.
		title_group = svg
			.append 'g'
			.attr 'transform', translate
		title_group
			.append 'text'
			.attr 'text-anchor', 'middle'
			.text title