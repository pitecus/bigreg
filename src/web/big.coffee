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
			plotPieChard gender, '#d3-gender-pie'

	# Plot pie chart.
	plotPieChard = (data, elementID) ->
		# DOM element.
		svg = d3.select elementID
		element = angular.element svg[0]
		
		# Retrieve the element size.
		width = element.attr 'width'
		height = element.attr 'height'
		radius = Math.min(width, height) / 2

		# Color.
		color = d3.scale.category10()

		# Pie.
		pie = d3.layout.pie()
			.sort null

		# Arc.
		arc = d3.svg.arc()
			.outerRadius radius

		# Add graph.
		graph = svg
			.attr 'width', width
			.attr 'height', height
			.append 'g'
			.attr 'transform', 'translate(' + width / 2 + ',' + height / 2 + ')'

		# Path.
		path = graph.selectAll 'path'
			.data pie [data.M, data.F]
			.enter()
			.append 'path'
			.attr 'fill', (d, i) ->
				color i
			.attr 'd', arc